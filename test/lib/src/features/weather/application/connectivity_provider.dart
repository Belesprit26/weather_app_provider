import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:untitled/src/features/weather/application/connectivity_provider.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late MockConnectivity mockConnectivity;
  late ConnectivityProvider connectivityProvider;

  setUp(() {
    mockConnectivity = MockConnectivity();
    connectivityProvider = ConnectivityProvider();
  });

  test('initially checks connection and updates status', () async {
    // Arrange
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.wifi);

    // Act
    connectivityProvider = ConnectivityProvider();
    await Future.delayed(Duration.zero); // Allow async code to run

    // Assert
    expect(connectivityProvider.hasConnection, true);
  });

  test('updates connection status when connectivity changes to none', () async {
    // Arrange
    when(mockConnectivity.onConnectivityChanged)
        .thenAnswer((_) => Stream.value(ConnectivityResult.none));

    // Act
    connectivityProvider = ConnectivityProvider();
    await Future.delayed(Duration.zero); // Allow async code to run

    // Assert
    expect(connectivityProvider.hasConnection, false);
  });

  test('updates connection status when connectivity changes to wifi', () async {
    // Arrange
    when(mockConnectivity.onConnectivityChanged)
        .thenAnswer((_) => Stream.value(ConnectivityResult.wifi));

    // Act
    connectivityProvider = ConnectivityProvider();
    await Future.delayed(Duration.zero); // Allow async code to run

    // Assert
    expect(connectivityProvider.hasConnection, true);
  });
}
