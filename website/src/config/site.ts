export interface AppReleaseConfig {
  version: string;
  releaseDate: string;
  apkDownloadUrl: string;
  apkFileName: string;
  apkSize: string;
  apkSizeBytes: number;
  sha256: string;
  minAndroidVersion: string;
  targetSdk: string;
  packageId: string;
  isDevnetBuild: boolean;
}

export interface SiteConfig {
  name: string;
  tagline: string;
  description: string;
  githubUrl: string;
  mlhUrl: string;
  demoVideoUrl?: string; // Optional YouTube / Loom URL
  contactEmail: string;
  release: AppReleaseConfig;
}

export const siteConfig: SiteConfig = {
  name: "SolePartner",
  tagline: "Your Voice. Your Ledger. Your AI Payment Agent.",
  description: "One intelligent business partner to manage daily transactions, customer credit, inventory, expenses, and payments for Indian retail merchants and kirana stores.",
  githubUrl: "https://github.com/ABHISHEK-DBZ/solepartner",
  mlhUrl: "https://events.mlh.io/events/15200-solana-hackathon",
  demoVideoUrl: undefined, // Displays high-fidelity interactive placeholder when not provided
  contactEmail: "abhibro936@gmail.com",
  release: {
    version: "v1.0.0",
    releaseDate: "November 8, 2026",
    apkDownloadUrl: "/downloads/solepartner.apk",
    apkFileName: "SolePartner-Android.apk",
    apkSize: "67.8 MB",
    apkSizeBytes: 71085315,
    sha256: "4469ee9efc487dd1d2725aecd1aec4b0b4b1b93acc2bb6e53aa441cb4d75c151",
    minAndroidVersion: "Android 8.0 (Oreo) or higher",
    targetSdk: "Android 14 (API 34)",
    packageId: "com.solepartner.app",
    isDevnetBuild: true,
  },
};

