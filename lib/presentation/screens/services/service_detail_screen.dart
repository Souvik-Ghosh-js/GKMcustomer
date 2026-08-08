import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/theme.dart';

// ─── Brand colours (green + white only) ────────────────────────────────────
const _kDark   = Color(0xFF03411A); // deepest forest
const _kMid    = Color(0xFF054D20); // mid forest
const _kLight  = Color(0xFF0A5C28); // lighter forest
const _kPanel  = Color(0xFF07200F); // drawer background
const _kBg     = Color(0xFF0D180B); // page background
const _kCard   = Color(0xFF112614); // card surface
const _kBorder = Color(0xFF1C3D22); // subtle border

// ─── Data model ─────────────────────────────────────────────────────────────
class ServiceInfo {
  final String id;
  final String title;
  final String overview;
  final IconData icon;
  final List<String> includes;
  final List<String> excludes;
  final List<String> howItsDone;
  final List<_FAQ> faqs;

  const ServiceInfo({
    required this.id,
    required this.title,
    required this.overview,
    required this.icon,
    required this.includes,
    required this.excludes,
    required this.howItsDone,
    required this.faqs,
  });
}

class _FAQ {
  final String q, a;
  const _FAQ(this.q, this.a);
}

// ─── Common FAQs ─────────────────────────────────────────────────────────────
const _commonFaqs = [
  _FAQ('Do you bring tools?',
      'Yes, our gardeners carry essential gardening tools.'),
  _FAQ('Do I need to provide water?',
      'Yes, please ensure water access is available.'),
  _FAQ('Can I buy plants and fertilizers from GharKaMali?',
      'Yes, these can be added during booking or purchased separately.'),
  _FAQ('Can I reschedule?', 'Yes, subject to availability.'),
];

// ─── All 15 services ─────────────────────────────────────────────────────────
const _allServices = [
  ServiceInfo(
    id: 'one_time',
    title: 'One-Time Plant Care',
    overview:
        'Professional visit for complete plant maintenance and basic plantation.',
    icon: Icons.bolt_rounded,
    includes: [
      'Watering plants',
      'Dry leaf removal',
      'Cleaning pots',
      'Soil loosening',
      'Basic pruning',
      'Basic weeding',
      'Plant rearrangement',
      'Garden cleanup',
      'Plant health inspection',
      'NEW: Plantation of customer-provided or GKM purchased plants',
    ],
    excludes: [
      'Landscape design',
      'Tree cutting',
      'Civil work',
      'Heavy pruning',
      'Repotting (unless booked)',
    ],
    howItsDone: [
      'Garden inspection',
      'Plant care & plantation',
      'Final cleanup',
    ],
    faqs: [
      ..._commonFaqs,
      _FAQ('Is new plantation included?',
          'Yes. Our gardener can plant new plants during the visit. Plants, pots and soil can be purchased from GharKaMali or provided by the customer.'),
    ],
  ),
  ServiceInfo(
    id: 'monthly',
    title: 'Monthly Plant Care Subscription',
    overview:
        'Regular scheduled visits to keep your garden healthy throughout the month.',
    icon: Icons.event_repeat_rounded,
    includes: [
      'Scheduled maintenance visits',
      'Watering',
      'Pruning',
      'Weeding',
      'Cleaning',
      'Soil loosening',
      'Plant inspection',
      'Garden cleanup',
      'NEW: Plantation of newly purchased plants during scheduled visits',
    ],
    excludes: [
      'Landscape execution',
      'Civil work',
      'Major tree cutting',
    ],
    howItsDone: [
      'Scheduled visit',
      'Maintenance & plantation',
      'Health check',
      'Next visit scheduled',
    ],
    faqs: [
      ..._commonFaqs,
      _FAQ('Can I add new plants anytime?',
          'Yes. New plantation is included during your scheduled maintenance visit.'),
    ],
  ),
  ServiceInfo(
    id: 'balcony',
    title: 'Balcony Garden Setup',
    overview: 'Design and installation of balcony gardens.',
    icon: Icons.balcony_rounded,
    includes: ['Professional service', 'Site inspection', 'Expert guidance'],
    excludes: ['Items outside selected package'],
    howItsDone: ['Inspection', 'Execution', 'Final quality check'],
    faqs: _commonFaqs,
  ),
  ServiceInfo(
    id: 'terrace',
    title: 'Terrace Garden Setup',
    overview: 'Complete terrace garden creation.',
    icon: Icons.roofing_rounded,
    includes: ['Professional service', 'Site inspection', 'Expert guidance'],
    excludes: ['Items outside selected package'],
    howItsDone: ['Inspection', 'Execution', 'Final quality check'],
    faqs: _commonFaqs,
  ),
  ServiceInfo(
    id: 'lawn_install',
    title: 'Lawn Installation',
    overview: 'Natural lawn installation.',
    icon: Icons.grass_rounded,
    includes: ['Professional service', 'Site inspection', 'Expert guidance'],
    excludes: ['Items outside selected package'],
    howItsDone: ['Inspection', 'Execution', 'Final quality check'],
    faqs: _commonFaqs,
  ),
  ServiceInfo(
    id: 'lawn_maint',
    title: 'Lawn Maintenance',
    overview: 'Routine lawn care.',
    icon: Icons.content_cut_rounded,
    includes: ['Professional service', 'Site inspection', 'Expert guidance'],
    excludes: ['Items outside selected package'],
    howItsDone: ['Inspection', 'Execution', 'Final quality check'],
    faqs: _commonFaqs,
  ),
  ServiceInfo(
    id: 'repotting',
    title: 'Plant Repotting',
    overview: 'Repotting with fresh soil.',
    icon: Icons.change_circle_rounded,
    includes: ['Professional service', 'Site inspection', 'Expert guidance'],
    excludes: ['Items outside selected package'],
    howItsDone: ['Inspection', 'Execution', 'Final quality check'],
    faqs: _commonFaqs,
  ),
  ServiceInfo(
    id: 'plant_doctor',
    title: 'Plant Doctor',
    overview: 'Plant diagnosis and treatment advice.',
    icon: Icons.medical_services_rounded,
    includes: ['Professional service', 'Site inspection', 'Expert guidance'],
    excludes: ['Items outside selected package'],
    howItsDone: ['Inspection', 'Execution', 'Final quality check'],
    faqs: _commonFaqs,
  ),
  ServiceInfo(
    id: 'pest_control',
    title: 'Plant Pest Control',
    overview: 'Treatment for pests and insects.',
    icon: Icons.pest_control_rounded,
    includes: ['Professional service', 'Site inspection', 'Expert guidance'],
    excludes: ['Items outside selected package'],
    howItsDone: ['Inspection', 'Execution', 'Final quality check'],
    faqs: _commonFaqs,
  ),
  ServiceInfo(
    id: 'kitchen_garden',
    title: 'Kitchen Garden Setup',
    overview: 'Vegetable garden installation.',
    icon: Icons.eco_rounded,
    includes: ['Professional service', 'Site inspection', 'Expert guidance'],
    excludes: ['Items outside selected package'],
    howItsDone: ['Inspection', 'Execution', 'Final quality check'],
    faqs: _commonFaqs,
  ),
  ServiceInfo(
    id: 'vertical',
    title: 'Vertical Garden',
    overview: 'Vertical green wall installation.',
    icon: Icons.view_column_rounded,
    includes: ['Professional service', 'Site inspection', 'Expert guidance'],
    excludes: ['Items outside selected package'],
    howItsDone: ['Inspection', 'Execution', 'Final quality check'],
    faqs: _commonFaqs,
  ),
  ServiceInfo(
    id: 'office',
    title: 'Office Plant Maintenance',
    overview: 'Office plant care.',
    icon: Icons.business_rounded,
    includes: ['Professional service', 'Site inspection', 'Expert guidance'],
    excludes: ['Items outside selected package'],
    howItsDone: ['Inspection', 'Execution', 'Final quality check'],
    faqs: _commonFaqs,
  ),
  ServiceInfo(
    id: 'society',
    title: 'Society Garden Maintenance',
    overview: 'Garden maintenance contracts.',
    icon: Icons.apartment_rounded,
    includes: ['Professional service', 'Site inspection', 'Expert guidance'],
    excludes: ['Items outside selected package'],
    howItsDone: ['Inspection', 'Execution', 'Final quality check'],
    faqs: _commonFaqs,
  ),
  ServiceInfo(
    id: 'shifting',
    title: 'Plant Shifting',
    overview: 'Safe relocation of plants.',
    icon: Icons.local_shipping_rounded,
    includes: ['Professional service', 'Site inspection', 'Expert guidance'],
    excludes: ['Items outside selected package'],
    howItsDone: ['Inspection', 'Execution', 'Final quality check'],
    faqs: _commonFaqs,
  ),
  ServiceInfo(
    id: 'landscape',
    title: 'Landscape Design',
    overview: 'Custom landscape planning.',
    icon: Icons.landscape_rounded,
    includes: ['Professional service', 'Site inspection', 'Expert guidance'],
    excludes: ['Items outside selected package'],
    howItsDone: ['Inspection', 'Execution', 'Final quality check'],
    faqs: _commonFaqs,
  ),
];

// ─── Screen ──────────────────────────────────────────────────────────────────
class ServiceDetailScreen extends StatefulWidget {
  final String? initialServiceId;
  const ServiceDetailScreen({super.key, this.initialServiceId});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen>
    with TickerProviderStateMixin {
  int _selected = 0;
  bool _drawerOpen = false;

  late final AnimationController _drawerCtrl;
  late final Animation<double> _drawerAnim;
  late final AnimationController _contentCtrl;
  late final Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();
    if (widget.initialServiceId != null) {
      final idx = _allServices
          .indexWhere((s) => s.id == widget.initialServiceId);
      if (idx >= 0) _selected = idx;
    }

    _drawerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 320));
    _drawerAnim = CurvedAnimation(
        parent: _drawerCtrl,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic);

    _contentCtrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        value: 1.0);
    _contentFade =
        CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _drawerCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    HapticFeedback.selectionClick();
    if (_drawerOpen) {
      _drawerCtrl.reverse();
    } else {
      _drawerCtrl.forward();
    }
    setState(() => _drawerOpen = !_drawerOpen);
  }

  Future<void> _selectService(int index) async {
    if (index == _selected) { _toggleDrawer(); return; }
    HapticFeedback.selectionClick();
    await _contentCtrl.reverse();
    setState(() {
      _selected = index;
      _drawerOpen = false;
    });
    _drawerCtrl.reverse();
    _contentCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final service = _allServices[_selected];
    final topPad = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _kBg,
        body: Stack(children: [
          // Subtle dot grid texture
          Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),

          // Main page shifts right when drawer opens
          AnimatedBuilder(
            animation: _drawerAnim,
            builder: (_, child) => Transform.translate(
              offset: Offset(
                  MediaQuery.of(context).size.width * 0.74 * _drawerAnim.value,
                  0),
              child: child,
            ),
            child: Column(children: [
              _AppBar(
                service: service,
                selected: _selected,
                total: _allServices.length,
                drawerAnim: _drawerAnim,
                onMenu: _toggleDrawer,
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: FadeTransition(
                  opacity: _contentFade,
                  child: _ServiceContent(service: service),
                ),
              ),
            ]),
          ),

          // Scrim
          AnimatedBuilder(
            animation: _drawerAnim,
            builder: (_, __) => _drawerAnim.value > 0
                ? GestureDetector(
                    onTap: _toggleDrawer,
                    child: Container(
                      color:
                          Colors.black.withValues(alpha: 0.5 * _drawerAnim.value),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Drawer
          AnimatedBuilder(
            animation: _drawerAnim,
            builder: (_, child) {
              final w = MediaQuery.of(context).size.width * 0.74;
              return Transform.translate(
                offset: Offset(-w + w * _drawerAnim.value, 0),
                child: SizedBox(width: w, child: child),
              );
            },
            child: _DrawerPanel(
              selected: _selected,
              onSelect: _selectService,
            ),
          ),
        ]),
      ),
    );
  }
}

// ─── App bar ─────────────────────────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  final ServiceInfo service;
  final int selected;
  final int total;
  final Animation<double> drawerAnim;
  final VoidCallback onMenu;
  final VoidCallback onBack;

  const _AppBar({
    required this.service,
    required this.selected,
    required this.total,
    required this.drawerAnim,
    required this.onMenu,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(16, top + 12, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_kLight, _kDark],
        ),
      ),
      child: Row(children: [
        // Hamburger
        GestureDetector(
          onTap: onMenu,
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.18), width: 1),
            ),
            child: AnimatedBuilder(
              animation: drawerAnim,
              builder: (_, __) =>
                  _HamburgerIcon(progress: drawerAnim.value),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Icon + title
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(service.icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(
              service.title,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${selected + 1} of $total services',
              style: GoogleFonts.poppins(
                  fontSize: 10.5,
                  color: Colors.white54,
                  fontWeight: FontWeight.w500),
            ),
          ]),
        ),

        // Back
        GestureDetector(
          onTap: onBack,
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15), width: 1),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 16),
          ),
        ),
      ]),
    );
  }
}

// ─── Hamburger → X ───────────────────────────────────────────────────────────
class _HamburgerIcon extends StatelessWidget {
  final double progress;
  const _HamburgerIcon({required this.progress});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 20,
        height: 20,
        child: Stack(alignment: Alignment.center, children: [
          Positioned(
            top: 3, left: 0, right: 0,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..translate(0.0, progress * 7)
                ..rotateZ(progress * math.pi / 4),
              child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2))),
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: 1 - progress,
            child: Container(
                height: 2,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2))),
          ),
          Positioned(
            bottom: 3, left: 0, right: 0,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..translate(0.0, -progress * 7)
                ..rotateZ(-progress * math.pi / 4),
              child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2))),
            ),
          ),
        ]),
      );
}

// ─── Drawer panel ────────────────────────────────────────────────────────────
class _DrawerPanel extends StatelessWidget {
  final int selected;
  final Future<void> Function(int) onSelect;

  const _DrawerPanel({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      decoration: const BoxDecoration(
        color: _kPanel,
        boxShadow: [
          BoxShadow(color: Colors.black54, blurRadius: 32, offset: Offset(6, 0))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, top + 14, 20, 18),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_kLight, _kDark],
            ),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(11),
              ),
              child:
                  const Icon(Icons.spa_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Our Services',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
              Text('${_allServices.length} services',
                  style: GoogleFonts.poppins(
                      fontSize: 10.5, color: Colors.white54)),
            ]),
          ]),
        ),

        // List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _allServices.length,
            itemBuilder: (_, i) {
              final s = _allServices[i];
              final sel = i == selected;
              return GestureDetector(
                onTap: () => onSelect(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13, vertical: 11),
                  decoration: BoxDecoration(
                    color: sel
                        ? _kLight.withValues(alpha: 0.55)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: sel
                          ? Colors.white.withValues(alpha: 0.18)
                          : Colors.white.withValues(alpha: 0.04),
                    ),
                  ),
                  child: Row(children: [
                    Icon(
                      s.icon,
                      size: 17,
                      color: sel ? Colors.white : Colors.white38,
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        s.title,
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight:
                              sel ? FontWeight.w700 : FontWeight.w400,
                          color:
                              sel ? Colors.white : Colors.white54,
                          height: 1.35,
                        ),
                      ),
                    ),
                    if (sel)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                      ),
                  ]),
                ),
              );
            },
          ),
        ),

        // Footer
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.06))),
          ),
          child: Text('© GharKaMali · Plantura Care Pvt Ltd',
              style:
                  GoogleFonts.poppins(fontSize: 10, color: Colors.white24)),
        ),
      ]),
    );
  }
}

// ─── Service content ─────────────────────────────────────────────────────────
class _ServiceContent extends StatefulWidget {
  final ServiceInfo service;
  const _ServiceContent({required this.service});

  @override
  State<_ServiceContent> createState() => _ServiceContentState();
}

class _ServiceContentState extends State<_ServiceContent> {
  final Set<int> _openFaqs = {};

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    return ListView(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 32),
      children: [
        _hero(s),
        const SizedBox(height: 20),
        _section(
          label: "WHAT'S INCLUDED",
          icon: Icons.check_circle_outline_rounded,
          child: _includesList(s.includes),
        ),
        const SizedBox(height: 14),
        _section(
          label: 'DOES NOT INCLUDE',
          icon: Icons.remove_circle_outline_rounded,
          child: _excludesList(s.excludes),
        ),
        const SizedBox(height: 14),
        _section(
          label: "HOW IT'S DONE",
          icon: Icons.format_list_numbered_rounded,
          child: _steps(s.howItsDone),
        ),
        const SizedBox(height: 14),
        _section(
          label: 'FREQUENTLY ASKED',
          icon: Icons.help_outline_rounded,
          child: _faqs(s.faqs),
        ),
        const SizedBox(height: 24),
        _cta(context),
        const SizedBox(height: 10),
      ],
    );
  }

  // ── Hero ─────────────────────────────────────────────────────────────────
  Widget _hero(ServiceInfo s) => Container(
        margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_kLight, _kDark],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.10), width: 1),
          boxShadow: [
            BoxShadow(
              color: _kDark.withValues(alpha: 0.6),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(children: [
          // Decorative circle
          Positioned(
            top: -20, right: -20,
            child: Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2), width: 1),
                ),
                child: Icon(s.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.22),
                          width: 1),
                    ),
                    child: Text(
                      'GHARKAMALI SERVICE',
                      style: GoogleFonts.poppins(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: Colors.white70,
                          letterSpacing: 0.8),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    s.title,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.25),
                  ),
                ]),
              ),
            ]),
            const SizedBox(height: 14),
            Text(
              s.overview,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white70,
                  height: 1.6),
            ),
          ]),
        ]),
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.05, end: 0, duration: 300.ms, curve: Curves.easeOut);

  // ── Section wrapper ───────────────────────────────────────────────────────
  Widget _section({
    required String label,
    required IconData icon,
    required Widget child,
  }) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: _kCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _kBorder, width: 1),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Section label
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(children: [
              Icon(icon, size: 15, color: Colors.white54),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white54,
                    letterSpacing: 0.9),
              ),
            ]),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: child),
        ]),
      )
          .animate()
          .fadeIn(duration: 350.ms, delay: 60.ms)
          .slideY(begin: 0.04, end: 0, duration: 300.ms, curve: Curves.easeOut);

  // ── Includes ──────────────────────────────────────────────────────────────
  Widget _includesList(List<String> items) => Column(
        children: items.map((item) {
          final isNew = item.startsWith('NEW:');
          final text = isNew ? item.replaceFirst('NEW: ', '') : item;
          return Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 1),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25), width: 1),
                ),
                child: const Icon(Icons.check_rounded,
                    size: 12, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Flexible(
                    child: Text(text,
                        style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.45)),
                  ),
                  if (isNew) ...[
                    const SizedBox(width: 6),
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1),
                      ),
                      child: Text('NEW',
                          style: GoogleFonts.poppins(
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.5)),
                    ),
                  ],
                ]),
              ),
            ]),
          );
        }).toList(),
      );

  // ── Excludes ──────────────────────────────────────────────────────────────
  Widget _excludesList(List<String> items) => Column(
        children: items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(top: 1),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.14), width: 1),
                  ),
                  child: const Icon(Icons.remove_rounded,
                      size: 12, color: Colors.white38),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(item,
                      style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          color: Colors.white38,
                          height: 1.45)),
                ),
              ]),
            )).toList(),
      );

  // ── Steps ─────────────────────────────────────────────────────────────────
  Widget _steps(List<String> steps) => Column(
        children: steps.asMap().entries.map((e) {
          final isLast = e.key == steps.length - 1;
          return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Column(children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                ),
                child: Text('${e.key + 1}',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
              ),
              if (!isLast)
                Container(
                  width: 1.5,
                  height: 26,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
            ]),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 6, bottom: isLast ? 0 : 18),
                child: Text(e.value,
                    style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.4)),
              ),
            ),
          ]);
        }).toList(),
      );

  // ── FAQs ──────────────────────────────────────────────────────────────────
  Widget _faqs(List<_FAQ> faqs) => Column(
        children: faqs.asMap().entries.map((e) {
          final open = _openFaqs.contains(e.key);
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                if (open) {
                  _openFaqs.remove(e.key);
                } else {
                  _openFaqs.add(e.key);
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.only(bottom: 7),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: open
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: open
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.07),
                ),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(
                    child: Text(e.value.q,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: open ? Colors.white : Colors.white70,
                            height: 1.35)),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: open ? Colors.white : Colors.white38,
                        size: 20),
                  ),
                ]),
                if (open) ...[
                  const SizedBox(height: 9),
                  Text(e.value.a,
                      style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          color: Colors.white54,
                          height: 1.6)),
                ],
              ]),
            ),
          );
        }).toList(),
      );

  // ── CTA ───────────────────────────────────────────────────────────────────
  Widget _cta(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/book'),
          child: Container(
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.bolt_rounded, color: _kDark, size: 20),
              const SizedBox(width: 8),
              Text('Book This Service',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: _kDark)),
            ]),
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 350.ms, delay: 150.ms)
          .slideY(begin: 0.08, end: 0, duration: 350.ms, curve: Curves.easeOut);
}

// ─── Dot grid texture ─────────────────────────────────────────────────────────
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.025)
      ..style = PaintingStyle.fill;
    const spacing = 22.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => false;
}
