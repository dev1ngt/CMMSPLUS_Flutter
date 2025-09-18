

sealed class PublicWebviewEvent {}

class PublicWebviewEventInit extends PublicWebviewEvent{}


class PublicWebviewQRScanResult extends PublicWebviewEvent {
  final String asset_code;
  PublicWebviewQRScanResult({
    required this.asset_code,
  });
}