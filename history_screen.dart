import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/bill_provider.dart';
import '../models/bill_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const Color _bg = Color(0xFF0D1117);
  static const Color _card = Color(0xFF161B22);
  static const Color _accent = Color(0xFF00C896);
  static const Color _textPrimary = Color(0xFFE6EDF3);
  static const Color _textSecondary = Color(0xFF8B949E);
  static const Color _border = Color(0xFF30363D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: _accent),
        title: Text('History',
            style: GoogleFonts.poppins(
                color: _textPrimary, fontWeight: FontWeight.w700)),
        actions: [
          Consumer<BillProvider>(
            builder: (context, provider, _) {
              if (provider.billHistory.isEmpty) return const SizedBox();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_rounded, color: Colors.red),
                tooltip: 'Clear All',
                onPressed: () => _confirmClearAll(context, provider),
              );
            },
          ),
        ],
      ),
      body: Consumer<BillProvider>(
        builder: (context, provider, _) {
          if (provider.billHistory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_rounded,
                      color: _textSecondary.withOpacity(0.4), size: 64),
                  const SizedBox(height: 16),
                  Text('No history yet',
                      style: GoogleFonts.poppins(
                          color: _textSecondary, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text('Save a bill split to see it here',
                      style: GoogleFonts.poppins(
                          color: _textSecondary.withOpacity(0.6),
                          fontSize: 13)),
                ],
              ),
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: provider.billHistory.length,
            itemBuilder: (context, index) {
              final bill = provider.billHistory[index];
              return _buildHistoryCard(context, bill, provider);
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(
      BuildContext context, BillModel bill, BillProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.receipt_rounded, color: _accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bill.title,
                    style: GoogleFonts.poppins(
                        color: _textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(
                  '${bill.numberOfPeople} people · ${bill.tipPercentage.toInt()}% tip · ${bill.date}',
                  style: GoogleFonts.poppins(
                      color: _textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${provider.currency} ${bill.perPersonAmount.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                    color: _accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
              Text('per person',
                  style:
                      GoogleFonts.poppins(color: _textSecondary, fontSize: 10)),
            ],
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _confirmDelete(context, bill, provider),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.delete_outline_rounded,
                  color: Colors.red.shade400, size: 17),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, BillModel bill, BillProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Entry',
            style: GoogleFonts.poppins(
                color: _textPrimary, fontWeight: FontWeight.w700)),
        content: Text('Delete "${bill.title}"?',
            style: GoogleFonts.poppins(color: _textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: _textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () async {
              await provider.deleteBill(bill.id!);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text('Delete',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, BillProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Clear All History',
            style: GoogleFonts.poppins(
                color: _textPrimary, fontWeight: FontWeight.w700)),
        content: Text('This will delete all saved records.',
            style: GoogleFonts.poppins(color: _textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: _textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () async {
              await provider.deleteAllBills();
              if (context.mounted) Navigator.pop(context);
            },
            child: Text('Clear All',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
