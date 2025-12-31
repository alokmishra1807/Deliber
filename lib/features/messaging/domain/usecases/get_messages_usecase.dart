import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/messaging/domain/entities/message_entity.dart';
import 'package:deliber/features/messaging/domain/repositories/message_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetMessagesUseCase {
  final MessageRepository messageRepository;

  GetMessagesUseCase(this.messageRepository);

  Future<Either<Failure, List<MessageEntity>>> call({required String userId}) {
    return messageRepository.getMessages(userId: userId);
  }
}
