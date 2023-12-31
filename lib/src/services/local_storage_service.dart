import 'local_storage_service_interface.dart';
import 'web/local_storage_service_web.dart'
    if (dart.library.io) 'mobile/local_storage_service_mobile.dart';

/// Returns an instance of LocalStorageServiceInterface.
///
/// This function determines the appropriate implementation of LocalStorageServiceInterface
/// based on the current platform (e.g., web or mobile) and returns an instance of it.
///
/// It uses conditional imports to decide which implementation to use:
/// - `LocalStorageServiceWeb` for web platforms.
/// - `LocalStorageServiceMobile` for mobile platforms.
LocalStorageServiceInterface getLocalStorageService() {
  // The conditional import ensures that the correct platform-specific implementation
  // is instantiated and returned.
  return LocalStorageService();
}
