import 'package:mocktail/mocktail.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_profile_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/update_profile_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/upload_avatar_usecase.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}
class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}
class MockUploadAvatarUseCase extends Mock implements UploadAvatarUseCase {}
