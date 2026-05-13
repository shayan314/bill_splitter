import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/bill_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  static const Color _bg = Color(0xFF0D1117);
  static const Color _card = Color(0xFF161B22);
  static const Color _accent = Color(0xFF00C896);
  static const Color _textPrimary = Color(0xFFE6EDF3);
  static const Color _textSecondary = Color(0xFF8B949E);
  static const Color _border = Color(0xFF30363D);

  void _showSaveDialog(BuildContext context, BillProvider provider) {
    final titleController = TextEditingController(text: 'Dinner Split');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Save to History',
            style: GoogleFonts.poppins(
                color: _textPrimary, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Give this split a name:',
                style: GoogleFonts.poppins(color: _textSecondary, fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              controller: titleController,
              style: GoogleFonts.poppins(color: _textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: _bg,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _border)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _border)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _accent)),
                hintText: 'e.g. Lunch, Trip, Party',
                hintStyle: GoogleFonts.poppins(color: _textSecondary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: _textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () async {
              final title = titleController.text.trim().isEmpty
                  ? 'Bill Split'
                  : titleController.text.trim();
              await provider.saveBill(title);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Saved to history!',
                        style: GoogleFonts.poppins(color: Colors.black)),
                    backgroundColor: _accent,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
            },
            child: Text('Save',
                style: GoogleFonts.poppins(
                    color: Colors.black, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BillProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: _bg,
          appBar: AppBar(
            backgroundColor: _bg,
            elevation: 0,
            iconTheme: const IconThemeData(color: _accent),
            title: Text(
              'Result',
              style: GoogleFonts.poppins(
                  color: _textPrimary, fontWeight: FontWeight.w700),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.save_rounded, color: _accent),
                tooltip: 'Save to History',
                onPressed: () => _showSaveDialog(context, provider),
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Hero result card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF00C896), Color(0xFF00A67E)],
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: _accent.withOpacity(0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Each Person Pays',
                        style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${provider.currency} ${provider.perPersonAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(height: 1, color: Colors.white.withOpacity(0.2)),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _statChip('People', '${provider.numberOfPeople}'),
                          Container(width: 1, height: 32, color: Colors.white.withOpacity(0.2)),
                          _statChip('Tip', '${provider.tipPercentage.toInt()}%'),
                          Container(width: 1, height: 32, color: Colors.white.withOpacity(0.2)),
                          _statChip('Total', '${provider.currency} ${provider.totalAmount.toStringAsFixed(0)}'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Breakdown Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.summarize_rounded, color: _accent, size: 18),
                          const SizedBox(width: 8),
                          Text('Breakdown',
                              style: GoogleFonts.poppins(
                                  color: _textSecondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _row('Bill Amount',
                          '${provider.currency} ${provider.billAmount.toStringAsFixed(2)}'),
                      const SizedBox(height: 10),
                      _row(
                          'Tip (${provider.tipPercentage.toInt()}%)',
                          '${provider.currency} ${provider.tipAmount.toStringAsFixed(2)}',
                          valueColor: _accent),
                      const SizedBox(height: 12),
                      Container(height: 1, color: _border),
                      const SizedBox(height: 12),
                      _row(
                          'Total',
                          '${provider.currency} ${provider.totalAmount.toStringAsFixed(2)}',
                          bold: true),
                      const SizedBox(height: 10),
                      _row(
                          'Per Person (${provider.numberOfPeople})',
                          '${provider.currency} ${provider.perPersonAmount.toStringAsFixed(2)}',
                          bold: true,
                          valueColor: _accent),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Per person list
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.people_rounded, color: _accent, size: 18),
                          const SizedBox(width: 8),
                          Text('Per Person',
                              style: GoogleFonts.poppins(
                                  color: _textSecondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ...List.generate(provider.numberOfPeople, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: _accent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text('${i + 1}',
                                      style: GoogleFonts.poppins(
                                          color: _accent,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text('Person ${i + 1}',
                                  style: GoogleFonts.poppins(
                                      color: _textPrimary, fontSize: 14)),
                              const Spacer(),
                              Text(
                                '${provider.currency} ${provider.perPersonAmount.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                    color: _accent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Save button
                GestureDetector(
                  onTap: () => _showSaveDialog(context, provider),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF00C896), Color(0xFF00A67E)]),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: _accent.withOpacity(0.3),
                            blurRadius: 14,
                            offset: const Offset(0, 5))
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.save_rounded,
                            color: Colors.black, size: 20),
                        const SizedBox(width: 8),
                        Text('Save to History',
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
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
    );
  }

  Widget _statChip(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        Text(label,
            style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.7), fontSize: 12)),
      ],
    );
  }

  Widget _row(String label, String value,
      {bool bold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                color: bold ? _textPrimary : _textSecondary,
                fontSize: bold ? 15 : 14,
                fontWeight: bold ? FontWeight.w600 : FontWeight.normal)),
        Text(value,
            style: GoogleFonts.poppins(
                color: valueColor ?? (bold ? _textPrimary : _textSecondary),
                fontSize: bold ? 15 : 14,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
      ],
    );
  }
}
