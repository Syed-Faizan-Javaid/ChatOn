import 'package:chat_app/chat/cubit/chat_cubit.dart';
import 'package:chat_app/chat/ui/chat_ui.dart';
import 'package:chat_app/constants/color.dart';
import 'package:chat_app/repositories/chat_repositories.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common_widgets/generic_dialogue.dart';
import 'models/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ChatCubit _chatCubit;
  late ChatRepository _chatRepository;
  List<UserDetail> members = [];
  late UserDetail _userDetail;

  @override
  void initState() {
    _chatRepository = ChatRepository();
    _chatCubit = ChatCubit(chatRepository: _chatRepository)..getMembers();
    _userDetail = context.read<UserRepository>().getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: primaryColor,
          toolbarHeight: 80,
          centerTitle: true,
          title: const Text(
            "SELECT MEMBER",
            style: TextStyle(fontSize: 16),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
          )),
      body: RepositoryProvider(
        create: (context) => _chatRepository,
        child: BlocProvider(
            create: (context) => _chatCubit,
            child: BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
              if (state is MembersFetched) {
                return state.members.isNotEmpty
                    ? Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.members.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    if (_userDetail.id == state.members[index].id) {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return GenericDialogue(
                                              content: "You Can't Chat with yourself",
                                            );
                                          });
                                    } else {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                                        return BlocProvider.value(
                                          value: _chatCubit,
                                          child: ChatUI(
                                            messageReceiverUserDetail: state.members[index],
                                          ),
                                        );
                                      }));
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        maxRadius: 30,
                                        backgroundColor: primaryColor,
                                        child: Text(
                                          state.members[index].email.substring(0, 1).toUpperCase(),
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.all(5.0),
                                      tileColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(20.0)),
                                      title: Text(
                                        state.members[index].email,
                                      ),
                                    ),
                                  ),
                                );
                              })
                        ],
                      )
                    : const Text("No Members Found");
              }
              return Container();
            })),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
