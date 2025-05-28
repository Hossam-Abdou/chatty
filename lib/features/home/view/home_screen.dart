import 'package:chatty/core/utils/app_colors.dart';
import 'package:chatty/features/home/view_model/chat_cubit.dart';
import 'package:chatty/features/home/widgets/custom_bottom_sheet.dart';
import 'package:chatty/features/home/widgets/home_app_bar.dart';
import 'package:chatty/features/home/widgets/search_filed.dart';
import 'package:chatty/features/home/widgets/users_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        var cubit = ChatCubit.get(context);
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 24.0, right: 6),
              child: SizedBox(
                width: 50, // Set your desired width
                height: 50, // Set your desired height
                child: FloatingActionButton(
                  shape: CircleBorder(),
                  backgroundColor: Colors.white,
                  onPressed: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      context: context,
                      builder: (context) {
                        return CustomBottomSheet(
                          usersWithoutMessages: cubit.getUsersWithoutMessages(),
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.add,
                    color: Color(0xff18ddfe),
                    size: 27,
                  ),
                ),
              ),
            ),
            backgroundColor: AppColors.primaryColor,
            appBar: const HomeAppBar(),
            body: Column(
              children: [
                SearchField(
                  controller: cubit.searchController,
                  onChange: (value) {
                    cubit.searchFieldChanged(value);
                  },
                ),
                UsersListTile(
                  homeStream: cubit.getHomeStream(),
                  searchQuery: cubit.searchQuery,
                  currentUserId: cubit.currentUserUid,
                ),

              ],
            ),
          ),
        );
      },
    );
  }

}
