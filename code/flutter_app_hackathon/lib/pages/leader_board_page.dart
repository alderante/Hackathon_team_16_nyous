import 'package:flutter/material.dart';
import 'package:hackatron_2/global_variables.dart';
class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  final String currentUser = 'You';

  @override
  Widget build(BuildContext context) {
    final updatedScores = Map<String, int>.from(triviaScores)
      ..[currentUser] = userTriviaScore.value;

    final sortedEntries = updatedScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Image(image: AssetImage('assets/logo_transparent.png'), height: MediaQuery.of(context).size.height * 0.08),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.pop(context);
                        }, // Placeholder: Add the Leaderboard placement
                        backgroundColor: Theme.of(context).colorScheme.onPrimary,
                        heroTag: "HeroBack",
                        tooltip: "Back",
                        child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          'LEADERBOARD',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox()
                    )
                  ]
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedEntries.length,
                    itemBuilder: (context, index) {
                      final name = sortedEntries[index].key;
                      final score = sortedEntries[index].value;
                      final isCurrentUser = name == currentUser;
            
                      return LeaderboardTile(
                        rank: index + 1,
                        name: name,
                        score: score,
                        isCurrentUser: isCurrentUser,
                      );
                    },
                  ),
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }
}

class LeaderboardTile extends StatefulWidget {
  final int rank;
  final String name;
  final int score;
  final bool isCurrentUser;

  const LeaderboardTile({
    super.key,
    required this.rank,
    required this.name,
    required this.score,
    required this.isCurrentUser,
  });

  @override
  State<LeaderboardTile> createState() => _LeaderboardTileState();
}

class _LeaderboardTileState extends State<LeaderboardTile> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int fullStars = (widget.score / 100).clamp(0, 5).floor();

    Widget _buildMedal() {
      switch (widget.rank) {
        case 1:
          return const Icon(Icons.emoji_events, color: Colors.amber, size: 28);
        case 2:
          return const Icon(Icons.emoji_events, color: Colors.grey, size: 28);
        case 3:
          return const Icon(Icons.emoji_events, color: Colors.brown, size: 28);
        default:
          return Text(
            '${widget.rank}',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          );
      }
    }

    return Card(
      color: widget.isCurrentUser ? const Color(0xFF0257FF) : Colors.blue.shade600,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: _buildMedal(),
        title: Row(
          children: [
            SizedBox(
              width: 120,
              child: Text(
                widget.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  if (index < fullStars) {
                    return ScaleTransition(
                      scale: _scaleAnimation,
                      child: const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                    );
                  } else {
                    return const Icon(
                      Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }
                }),
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
        trailing: Text(
          widget.score.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}




