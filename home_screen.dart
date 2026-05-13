import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/bill_provider.dart';
import 'result_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _billController = TextEditingController();

  static const Color _bg = Color(0xFF0D1117);
  static const Color _card = Color(0xFF161B22);
  static const Color _accent = Color(0xFF00C896);
  static const Color _textPrimary = Color(0xFFE6EDF3);
  static const Color _textSecondary = Color(0xFF8B949E);
  static const Color _border = Color(0xFF30363D);

  @override
  void dispose() {
    _billController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<BillProvider>();
      provider.setBillAmount(double.parse(_billController.text));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ResultScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: Text(
          'Bill Splitter',
          style: GoogleFonts.poppins(
            color: _textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: _accent),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: _accent),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<BillProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Split your bill\nfairly & quickly',
                    style: GoogleFonts.poppins(
                      color: _textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Enter details below to calculate',
                    style: GoogleFonts.poppins(
                        color: _textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 28),

                  // Bill Amount
                  _buildSectionLabel('Total Bill Amount', Icons.attach_money_rounded),
                  const SizedBox(height: 10),
                  _buildBillField(provider),
                  const SizedBox(height: 20),

                  // Number of People
                  _buildSectionLabel('Number of People', Icons.group_rounded),
                  const SizedBox(height: 10),
                  _buildPeopleSelector(provider),
                  const SizedBox(height: 20),

                  // Tip
                  _buildSectionLabel('Tip Percentage', Icons.star_rounded),
                  const SizedBox(height: 10),
                  _buildTipSelector(provider),
                  const SizedBox(height: 32),

                  // Calculate Button
                  GestureDetector(
                    onTap: _calculate,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00C896), Color(0xFF00A67E)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: _accent.withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calculate_rounded,
                              color: Colors.black, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Calculate',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reset
                  GestureDetector(
                    onTap: () {
                      provider.reset();
                      _billController.clear();
                      HapticFeedback.lightImpact();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh_rounded,
                              color: Colors.red.shade400, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Reset',
                            style: GoogleFonts.poppins(
                              color: Colors.red.shade400,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: _accent, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: _textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBillField(BillProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: TextFormField(
        controller: _billController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
        ],
        style: GoogleFonts.poppins(
            color: _textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          prefixText: '${provider.currency} ',
          prefixStyle: GoogleFonts.poppins(
              color: _accent, fontSize: 20, fontWeight: FontWeight.w600),
          hintText: '0.00',
          hintStyle: GoogleFonts.poppins(color: _textSecondary),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          errorStyle: GoogleFonts.poppins(color: Colors.red.shade400),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the bill amount';
          }
          final amount = double.tryParse(value);
          if (amount == null || amount <= 0) {
            return 'Please enter a valid amount greater than 0';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPeopleSelector(BillProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _counterBtn(Icons.remove_rounded,
                  () => provider.setNumberOfPeople(provider.numberOfPeople - 1),
                  provider.numberOfPeople > 1),
              const SizedBox(width: 24),
              SizedBox(
                width: 60,
                child: Text(
                  '${provider.numberOfPeople}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: _textPrimary,
                      fontSize: 36,
                      fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 24),
              _counterBtn(Icons.add_rounded,
                  () => provider.setNumberOfPeople(provider.numberOfPeople + 1),
                  provider.numberOfPeople < 20),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [2, 3, 4, 5, 6].map((n) {
              final selected = provider.numberOfPeople == n;
              return GestureDetector(
                onTap: () => provider.setNumberOfPeople(n),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: selected ? _accent : _accent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: selected ? _accent : _accent.withOpacity(0.2)),
                  ),
                  child: Text(
                    '$n',
                    style: GoogleFonts.poppins(
                      color: selected ? Colors.black : _accent,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTipSelector(BillProvider provider) {
    final tipOptions = [0.0, 5.0, 10.0, 15.0, 20.0, 25.0];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: tipOptions.map((tip) {
              final selected = provider.tipPercentage == tip;
              return GestureDetector(
                onTap: () => provider.setTipPercentage(tip),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 44,
                  decoration: BoxDecoration(
                    color: selected ? _accent : _accent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: selected ? _accent : _accent.withOpacity(0.2)),
                  ),
                  child: Center(
                    child: Text(
                      '${tip.toInt()}%',
                      style: GoogleFonts.poppins(
                        color: selected ? Colors.black : _accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Custom',
                  style:
                      GoogleFonts.poppins(color: _textSecondary, fontSize: 13)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${provider.tipPercentage.toInt()}%',
                  style: GoogleFonts.poppins(
                      color: _accent, fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _accent,
              inactiveTrackColor: _accent.withOpacity(0.15),
              thumbColor: _accent,
              overlayColor: _accent.withOpacity(0.1),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              trackHeight: 4,
            ),
            child: Slider(
              value: provider.tipPercentage,
              min: 0,
              max: 50,
              divisions: 50,
              onChanged: (val) => provider.setTipPercentage(val),
            ),
          ),
        ],
      ),
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback onTap, bool enabled) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color:
              enabled ? _accent.withOpacity(0.15) : _border.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: enabled ? _accent.withOpacity(0.4) : _border),
        ),
        child: Icon(icon,
            color: enabled ? _accent : _textSecondary.withOpacity(0.3),
            size: 22),
      ),
    );
  }
}
