import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/messaging/domain/entities/message_entity.dart';
import 'package:deliber/features/messaging/domain/repositories/message_repository.dart';
import 'package:fpdart/fpdart.dart';

class SendMessageUseCase {
  final MessageRepository messageRepository;

  SendMessageUseCase(this.messageRepository);

  Future<Either<Failure, MessageEntity>> call({
    required String receiverId,
    required String message,
  }) {
    return messageRepository.sendMessage(
      receiverId: receiverId,
      message: message,
    );
  }
}
