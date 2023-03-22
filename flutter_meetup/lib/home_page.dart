import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/app_state.dart';
import 'package:flutter_meetup/auth_action.dart';
import 'package:flutter_meetup/widgets.dart';
import 'package:provider/provider.dart';
import 'guest_book.dart';
import 'yes_no_selection.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Meetup'),
      ),
      body: ListView(
        children: [
          Image.asset('assets/header.png'),
          const IconAndDetail(Icons.calendar_month, '1er Avril'),
          const IconAndDetail(Icons.location_city, 'Annecy'),
          Consumer<ApplicationState>(builder: (context, appState, _) {
            return AuthAction(
              loggedIn: appState.loggedIn,
              signOut: () {
                FirebaseAuth.instance.signOut();
              },
            );
          }),
          const Header('Discussion'),
          Consumer<ApplicationState>(builder: (context, appState, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.loggedIn)
                  GuestBook(
                    addMessage: (message) =>
                        appState.addMessageToGuestBook(message),
                    messages: appState.guestBookMessages,
                  ),
              ],
            );
          }),
          Consumer<ApplicationState>(builder: (context, appState, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.attendees >= 2)
                  Paragraph('${appState.attendees} participants')
                else if (appState.attendees == 1)
                  const Paragraph('1 participant')
                else
                  const Paragraph('Aucun participant'),
                if (appState.loggedIn) ...[
                  YesNoSelection(
                    state: appState.attending,
                    onSelection: (attending) => appState.attending = attending,
                  ),
                  const Header('Discussion'),
                  GuestBook(
                    addMessage: (message) =>
                        appState.addMessageToGuestBook(message),
                    messages: appState.guestBookMessages,
                  ),
                ],
              ],
            );
          }),
          const Header('Au programme'),
          const Paragraph(
              "Rejoignez-nous pour une journée pleine de démos, d'échanges, et de pizza !"),
        ],
      ),
    );
  }
}
