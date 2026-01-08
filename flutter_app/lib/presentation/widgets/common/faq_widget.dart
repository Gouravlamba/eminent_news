import 'package:flutter/material.dart';

class FAQWidget extends StatelessWidget {
  const FAQWidget({super.key});

  final List<Map<String, String>> _faqData = const [
    {
      'question': 'What type of news do you provide?',
      'answer':
          'We cover breaking news, politics, technology, entertainment, sports, and global current affairs.  Our platform is updated every minute with verified information.',
    },
    {
      'question': 'What are Shorts on this website?',
      'answer':
          'Shorts are quick, snackable video clips under 60 seconds that summarize trending news stories in an engaging format.',
    },
    {
      'question': 'Do you upload daily video news?',
      'answer':
          'Yes.  Our video team posts daily summaries, interviews, and explainers covering the most important events of the day.',
    },
    {
      'question': 'How often is the news updated?',
      'answer':
          'Our newsroom updates stories in real-time.  You will always find the latest verified updates on our homepage.',
    },
    {
      'question': 'How do I submit news or report an issue?',
      'answer':
          'You can reach us through the contact page or email our editorial team with supporting details or evidence.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequently Asked Questions',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(_faqData.length, (index) {
          return ExpansionTile(
            title: Text(
              _faqData[index]['question']!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _faqData[index]['answer']!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
