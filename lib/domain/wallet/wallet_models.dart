import 'package:flutter/foundation.dart';

enum WalletConnectionStatus {
  disconnected,
  connecting,
  connected,
  unsupported,
  error,
}

enum SolanaCluster {
  devnet,
  testnet,
  mainnetBeta,
}

extension SolanaClusterX on SolanaCluster {
  String get name {
    switch (this) {
      case SolanaCluster.devnet:
        return 'devnet';
      case SolanaCluster.testnet:
        return 'testnet';
      case SolanaCluster.mainnetBeta:
        return 'mainnet-beta';
    }
  }

  String get displayName {
    switch (this) {
      case SolanaCluster.devnet:
        return 'Solana Devnet (Test)';
      case SolanaCluster.testnet:
        return 'Solana Testnet';
      case SolanaCluster.mainnetBeta:
        return 'Solana Mainnet (Live)';
    }
  }

  bool get isLiveMoney => this == SolanaCluster.mainnetBeta;
}

@immutable
class WalletAccount {
  const WalletAccount({
    required this.address,
    this.label,
    this.icon,
  });

  final String address;
  final String? label;
  final String? icon;

  String get truncatedAddress {
    if (address.length <= 10) return address;
    return '${address.substring(0, 4)}...${address.substring(address.length - 4)}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletAccount &&
          runtimeType == other.runtimeType &&
          address == other.address;

  @override
  int get hashCode => address.hashCode;
}

@immutable
class WalletState {
  const WalletState({
    required this.status,
    required this.cluster,
    this.account,
    this.balanceLamports,
    this.balanceError,
    this.errorMessage,
    this.lastActivity,
    this.isMwaSupported = true,
  });

  final WalletConnectionStatus status;
  final SolanaCluster cluster;
  final WalletAccount? account;
  final int? balanceLamports;
  final String? balanceError;
  final String? errorMessage;
  final DateTime? lastActivity;
  final bool isMwaSupported;

  bool get isConnected =>
      status == WalletConnectionStatus.connected && account != null;

  String? get address => account?.address;

  WalletState copyWith({
    WalletConnectionStatus? status,
    SolanaCluster? cluster,
    WalletAccount? account,
    int? balanceLamports,
    String? balanceError,
    String? errorMessage,
    DateTime? lastActivity,
    bool? isMwaSupported,
    bool clearAccount = false,
  }) {
    return WalletState(
      status: status ?? this.status,
      cluster: cluster ?? this.cluster,
      account: clearAccount ? null : (account ?? this.account),
      balanceLamports: clearAccount ? null : (balanceLamports ?? this.balanceLamports),
      balanceError: balanceError,
      errorMessage: errorMessage,
      lastActivity: lastActivity ?? this.lastActivity,
      isMwaSupported: isMwaSupported ?? this.isMwaSupported,
    );
  }

  static const WalletState disconnected = WalletState(
    status: WalletConnectionStatus.disconnected,
    cluster: SolanaCluster.devnet,
  );
}

