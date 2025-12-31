import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/messaging/domain/entities/user_entity.dart';
import 'package:deliber/features/messaging/domain/repositories/message_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUsersUseCase {
  final MessageRepository messageRepository;

  GetUsersUseCase(this.messageRepository);

  Future<Either<Failure, List<UserEntity>>> call() {
    return messageRepository.getUsers();
  }
}
