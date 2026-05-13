import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/bill_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Color _bg = Color(0xFF0D1117);
  static const Color _card = Color(0xFF161B22);
  static const Color _accent = Color(0xFF00C896);
  static const Color _textPrimary = Color(0xFFE6EDF3);
  static const Color _textSecondary = Color(0xFF8B949E);
  static const Color _border = Color(0xFF30363D);

  final List<String> _currencies = const ['Rs.', '\$', '€', '£', '¥', '₹'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: _accent),
        title: Text('Settings',
            style: GoogleFonts.poppins(
                color: _textPrimary, fontWeight: FontWeight.w700)),
      ),
      body: Consumer<BillProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel('Preferences'),
                const SizedBox(height: 12),

                // Currency
                _settingsCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.currency_exchange_rounded,
                              color: _accent, size: 18),
                          const SizedBox(width: 8),
                          Text('Currency',
                              style: GoogleFonts.poppins(
                                  color: _textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _currencies.map((c) {
                          final selected = provider.currency == c;
                          return GestureDetector(
                            onTap: () => provider.updateCurrency(c),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: selected
                                    ? _accent
                                    : _accent.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: selected
                                        ? _accent
                                        : _accent.withOpacity(0.2)),
                              ),
                              child: Text(c,
                                  style: GoogleFonts.poppins(
                                      color: selected
                                          ? Colors.black
                                          : _accent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14)),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Default Tip
                _settingsCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: _accent, size: 18),
                              const SizedBox(width: 8),
                              Text('Default Tip',
                                  style: GoogleFonts.poppins(
                                      color: _textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _accent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('${provider.defaultTip.toInt()}%',
                                style: GoogleFonts.poppins(
                                    color: _accent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: _accent,
                          inactiveTrackColor: _accent.withOpacity(0.15),
                          thumbColor: _accent,
                          overlayColor: _accent.withOpacity(0.1),
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8),
                          trackHeight: 4,
                        ),
                        child: Slider(
                          value: provider.defaultTip,
                          min: 0,
                          max: 50,
                          divisions: 50,
                          onChanged: (val) => provider.updateDefaultTip(val),
                        ),
                      ),
                      Text(
                        'This will be the pre-selected tip on every new bill',
                        style: GoogleFonts.poppins(
                            color: _textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Default People
                _settingsCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.group_rounded,
                                  color: _accent, size: 18),
                              const SizedBox(width: 8),
                              Text('Default People',
                                  style: GoogleFonts.poppins(
                                      color: _textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _accent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('${provider.defaultPeople}',
                                style: GoogleFonts.poppins(
                                    color: _accent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: _accent,
                          inactiveTrackColor: _accent.withOpacity(0.15),
                          thumbColor: _accent,
                          overlayColor: _accent.withOpacity(0.1),
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8),
                          trackHeight: 4,
                        ),
                        child: Slider(
                          value: provider.defaultPeople.toDouble(),
                          min: 1,
                          max: 10,
                          divisions: 9,
                          onChanged: (val) =>
                              provider.updateDefaultPeople(val.toInt()),
                        ),
                      ),
                      Text(
                        'Default number of people to split between',
                        style: GoogleFonts.poppins(
                            color: _textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                _sectionLabel('About'),
                const SizedBox(height: 12),
                _settingsCard(
                  child: Column(
                    children: [
                      _aboutRow(Icons.info_outline_rounded, 'App Name',
                          'Bill Splitter'),
                      const Divider(color: _border, height: 20),
                      _aboutRow(Icons.school_rounded, 'Project',
                          'MAD Section B'),
                      const Divider(color: _border, height: 20),
                      _aboutRow(Icons.code_rounded, 'Technology', 'Flutter'),
                      const Divider(color: _border, height: 20),
                      _aboutRow(Icons.tag_rounded, 'Version', '1.0.0'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.poppins(
          color: _textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  Widget _settingsCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: child,
    );
  }

  Widget _aboutRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: _accent, size: 18),
        const SizedBox(width: 12),
        Text(label,
            style: GoogleFonts.poppins(color: _textSecondary, fontSize: 13)),
        const Spacer(),
        Text(value,
            style: GoogleFonts.poppins(
                color: _textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}
