import 'package:flutter/material.dart';

class AccountSetting{
  final String title;
  final String subtitle;
  final Icon icon;

  AccountSetting({
    this.title,
    this.subtitle,
    this.icon,
  });

}

List<AccountSetting> accountSettings = [
  AccountSetting(
    title: 'Emeruche',
    subtitle: '~',
    icon: Icon(Icons.person_pin),
  ),
  AccountSetting(
    title: 'Account',
    subtitle: 'Privacy, security, change number',
    icon: Icon(Icons.security),
  ),
  AccountSetting(
    title: 'Chats',
    subtitle: 'Theme, Wallpapers, chat history',
    icon: Icon(Icons.chat),
  ),
  AccountSetting(
    title: 'Notifications',
    subtitle: 'Message, group & call tones',
    icon: Icon(Icons.notifications),
  ),
  AccountSetting(
    title: 'Data and storage usage',
    subtitle: 'Network usage, auto-download',
    icon: Icon(Icons.alarm),
  ),
  AccountSetting(
    title: 'Help',
    subtitle: 'FAQ, contact us, privacy policy',
    icon: Icon(Icons.help_outline),
  ),
  AccountSetting(
    title: 'Invite a friend',
    subtitle: '',
    icon: Icon(Icons.people),
  ),
  
];