import 'package:expense_tracker_app/screens/stats/views/chart.dart';
import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(12, 20, 12, 12),
                child: MyChart(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
