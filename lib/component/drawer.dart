import 'package:flutter/material.dart';
import 'package:kuboardverth/component/mylisttitle.dart';
class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  final void Function()? onChataTap;
  final void Function()? onSettingTap;
  final void Function()? onNewpage;
  final void Function()? onGroupTap;

  const MyDrawer({
    super.key,
    required this.onProfileTap,
    required this.onSignOut,
    required this.onChataTap,
    required this.onSettingTap,
    required this.onNewpage,
    required this.onGroupTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //header listttile
              const DrawerHeader(

                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              //home listitile
              MylistTitle(
                icon: Icons.home,
                text: 'Home',
                onTap: ()=>Navigator.pop(context),
              ),
              new
              MylistTitle(
                  icon: Icons.newspaper,
                  text: 'News',
                  onTap: onNewpage),
              //profile list titile
              MylistTitle(
                  icon: Icons.person,
                  text: 'Profile',
                  onTap: onProfileTap),
              MylistTitle(
                  icon: Icons.chat,
                  text: 'Chat',
                  onTap: onChataTap),
              MylistTitle(
                  icon: Icons.group,
                  text: 'Group',
                  onTap: onGroupTap),
              MylistTitle(
                  icon: Icons.settings,
                  text: 'Setting',
                  onTap: onSettingTap),
            ],
          ),
          //logout
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MylistTitle(
                icon: Icons.logout,
                text: 'Logout',
                onTap: onSignOut),
          ),

        ],
      ),
    );
  }
}
