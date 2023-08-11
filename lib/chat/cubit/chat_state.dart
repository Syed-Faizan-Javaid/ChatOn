part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();
}

class ChatInitial extends ChatState {
  @override
  List<Object> get props => [];
}

class ChatLoading extends ChatState {
  @override
  List<Object?> get props => [];
}

class MembersFetched extends ChatState {
  final List<UserDetail> members;
  const MembersFetched({required this.members});
  @override
  List<Object?> get props => [];
}

class ErrorInServer extends ChatState {
  final String? error;
  const ErrorInServer({required this.error});
  @override
  List<Object?> get props => [];
}
