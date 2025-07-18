import 'package:flutter/material.dart'; 
import 'package:ecomentor/screens/courses/AQI_Science.dart';
import 'package:ecomentor/screens/courses/Carbon_Footprint.dart';
import 'package:ecomentor/screens/courses/Climate_Science.dart';
import 'package:ecomentor/screens/courses/Future_Tech.dart'; 
import 'package:ecomentor/screens/courses/Zero_Waste.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 24),
          _buildCurrentCourse(),
          const SizedBox(height: 24),
          _buildCourseList(context), // New function to display the 5 courses
          const SizedBox(height: 24),
          _buildPopularCourses(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search courses...',
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textSecondary,
        ),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildCurrentCourse() {
    return Card(
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    Icons.eco,
                    size: 120,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'In Progress',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Introduction to Climate Change',
                        style: AppTextStyles.h3.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.play_circle_outline,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Lesson 4 of 12',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '33% Complete',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: 0.33,
                  backgroundColor: AppColors.background,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.success,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Continue Learning'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// **NEW: Function to Display Course List**
  Widget _buildCourseList(BuildContext context) {
    final courses = [
      {
        'title': '📖 Course 1: AQI & The Science of Air Pollution 🌫️',
        'topics': [
          '📌 What is AQI & how is it calculated? (Live AQI tracker)',
          '📌 Health & climate effects of bad air',
          '📌 How different countries monitor AQI',
          '📌 Hands-on: Create your own AQI sensor',
        ],
        'page': const AQI_Science(), // Navigate to AQI Science Page
      },
      {
        'title': '📖 Course 2: Carbon Footprint & Sustainable Living 🌍',
        'topics': [
          '📌 What is a carbon footprint?',
          '📌 Step-by-step breakdown of carbon footprint calculation',
          '📌 Case study: How countries are reducing emissions',
          '📌 Hands-on: Carbon footprint calculator + daily tracker',
        ],
        'page': const Carbon_Footprint(),
      },
      {
        'title': '📖 Course 3: Climate Science & Global Warming 🔥❄️',
        'topics': [
          '📌 The natural vs. human-driven climate change',
          '📌 Data-driven climate predictions',
          '📌 Case studies: The most affected regions',
          '📌 Hands-on: Create a home CO₂ monitor',
        ],
        'page': const Climate_Science(),
      },
      
      // {
      //   'title': '📖 Course 4: Circular Economy & Zero Waste ♻️',
      //   'topics': [
      //     '📌 Why plastic & waste impact climate change',
      //     '📌 How recycling & composting work',
      //     '📌 Success stories: Cities that banned plastic',
      //     '📌 Hands-on: Make a compost bin at home',
      //   ],
      //   'page': const Zero_Waste(),
      // },
      // {
      //   'title': '📖 Course 5: Future Tech & Climate Innovation 🚀',
      //   'topics': [
      //     '📌 AI, IoT & blockchain in climate monitoring',
      //     '📌 Renewable energy & futuristic solutions',
      //     '📌 How space research helps climate science',
      //     '📌 Hands-on: DIY solar panel project',
      //   ],
      //   'page': const Future_Tech(),
      // },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: courses.map((course) {
        return _buildCourseTile(
          title: course['title'] as String,
          topics: course['topics'] as List<String>,
          context: context,
          page: course['page'],
        );
      }).toList(),
    );
  }

  Widget _buildCourseTile({
    required String title,
    required List<String> topics,
    required BuildContext context,
    dynamic page,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.h3),
            const SizedBox(height: 10),
            ...topics.map((topic) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(topic, style: AppTextStyles.bodyMedium),
                )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: page != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => page),
                        );
                      }
                    : null,
                child: const Text('Start Course'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularCourses() {
    return const SizedBox(); // Keeping it unchanged
  }
}
