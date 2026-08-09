import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import '../../presentation/widgets/widgets.dart';
import 'api.dart';

// ─── Invoice download service ─────────────────────────────────────────────────
// The backend renders the canonical PDF invoice; the app never builds one.
// GET <kBase><endpoint> streams application/pdf — we save it to the temp dir
// and hand it to the platform PDF viewer via open_filex.

enum InvoiceType { booking, subscription, order }

String _invoicePath(InvoiceType type, int id) => switch (type) {
  InvoiceType.booking      => '/bookings/$id/invoice',
  InvoiceType.subscription => '/subscriptions/$id/invoice',
  InvoiceType.order        => '/shop/orders/$id/invoice',
};

// The ONE shared helper — every "Download Invoice" action in the app calls this.
Future<void> downloadInvoice(BuildContext context, InvoiceType type, int id) async {
  try {
    final token = await Api().token();
    if (token == null || token.isEmpty) {
      if (context.mounted) showMsg(context, 'Please log in again to download your invoice.', err: true);
      return;
    }

    if (context.mounted) showMsg(context, 'Downloading invoice…');

    final res = await http.get(
      Uri.parse('$kBase${_invoicePath(type, id)}'),
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(const Duration(seconds: 40));

    if (res.statusCode < 200 || res.statusCode >= 300) {
      String msg = 'Could not download invoice (Error ${res.statusCode}).';
      try {
        final j = jsonDecode(utf8.decode(res.bodyBytes));
        if (j is Map && j['message'] is String && (j['message'] as String).isNotEmpty) {
          msg = j['message'] as String;
        }
      } catch (_) {}
      if (context.mounted) showMsg(context, msg, err: true);
      return;
    }

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/invoice-${type.name}-$id.pdf');
    await file.writeAsBytes(res.bodyBytes, flush: true);

    final result = await OpenFilex.open(file.path);
    if (result.type != ResultType.done && context.mounted) {
      showMsg(context, 'Invoice saved, but no PDF viewer could open it.', err: true);
    }
  } on SocketException {
    if (context.mounted) showMsg(context, 'No internet connection. Please check your network.', err: true);
  } on TimeoutException {
    if (context.mounted) showMsg(context, 'Request timed out. Please try again.', err: true);
  } catch (_) {
    if (context.mounted) showMsg(context, 'Could not download invoice. Please try again.', err: true);
  }
}
