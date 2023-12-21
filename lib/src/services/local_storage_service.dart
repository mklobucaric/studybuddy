import 'local_storage_service_interface.dart';
import 'web/local_storage_service_web.dart'
    if (dart.library.io) 'mobile/local_storage_service_mobile.dart';

LocalStorageServiceInterface getLocalStorageService() {
  // Check the platform and return the appropriate implementation
  return LocalStorageService();
}
