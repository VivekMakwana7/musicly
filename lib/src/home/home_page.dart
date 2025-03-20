import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/src/home/cubit/home_cubit.dart';
import 'package:musicly/src/home/widgets/recent_played_song_widget.dart';

/// Home Page
class HomePage extends StatelessWidget {
  /// Home Page Constructor
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text(greeting)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [SizedBox(height: 20.h), const RecentPlayedSongWidget()],
        ),
      ),
    );
  }

  /// Returns an appropriate greeting based on the current hour of the day
  String get greeting {
    final hour = DateTime.now().hour;

    if (hour >= 0 && hour < 5) {
      return 'Good Night';
    } else if (hour < 12) {
      return 'Good Morning';
    } else if (hour == 12) {
      return 'Good Noon';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else if (hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }
}
