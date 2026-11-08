import React, { useState } from 'react';
import { Download, ShieldCheck, Check, Copy, ExternalLink, AlertCircle, FileCode } from 'lucide-react';
import { siteConfig } from '../config/site';

export const APKDownloadCard: React.FC = () => {
  const [copiedHash, setCopiedHash] = useState(false);

  const handleCopyHash = () => {
    navigator.clipboard.writeText(siteConfig.release.sha256);
    setCopiedHash(true);
    setTimeout(() => setCopiedHash(false), 2000);
  };

  return (
    <section id="download" className="py-24 bg-[#06101E] relative">
      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-14">
          <span className="text-xs font-semibold uppercase tracking-wider text-emerald-400 bg-emerald-950/60 border border-emerald-500/30 px-3.5 py-1.5 rounded-full">
            Direct Android Installation
          </span>
          <h2 className="mt-4 text-3xl sm:text-5xl font-extrabold text-white tracking-tight">
            Your Business Partner Is{' '}
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-emerald-400 to-teal-300">
              One Download Away.
            </span>
          </h2>
          <p className="mt-3 text-base text-slate-300">
            Download SolePartner for Android and experience a smarter, voice-first way to manage your kirana store.
          </p>
        </div>

        {/* Emerald Download Card */}
        <div className="relative rounded-3xl p-8 sm:p-12 bg-gradient-to-br from-[#0B1A2E] via-[#0D2438] to-[#071324] border border-emerald-500/40 shadow-2xl shadow-emerald-950/50 overflow-hidden">
          {/* Subtle Top-Right Corner Glow */}
          <div className="absolute top-0 right-0 w-80 h-80 bg-emerald-500/15 rounded-full blur-3xl pointer-events-none" />

          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center relative z-10">
            {/* Left: App Identity & Specifications */}
            <div className="lg:col-span-7 space-y-6">
              <div className="flex items-center gap-4">
                <div className="w-16 h-16 rounded-2xl overflow-hidden shadow-lg border border-emerald-400/30 bg-[#06101E] shrink-0">
                  <img
                    src="/images/app_icon.png"
                    alt="SolePartner App Icon"
                    className="w-full h-full object-cover"
                  />
                </div>
                <div>
                  <h3 className="text-2xl font-bold text-white flex items-center gap-2">
                    SolePartner
                    <span className="text-xs font-semibold bg-emerald-500/20 text-emerald-300 border border-emerald-400/40 px-2 py-0.5 rounded-full">
                      Android APK
                    </span>
                  </h3>
                  <p className="text-sm text-slate-400">
                    Package: <code className="text-emerald-400">{siteConfig.release.packageId}</code>
                  </p>
                </div>
              </div>

              {/* Verified Metadata Matrix */}
              <div className="grid grid-cols-2 sm:grid-cols-3 gap-4 pt-4 border-t border-slate-700/60">
                <div>
                  <p className="text-xs text-slate-400 font-medium">Version</p>
                  <p className="text-sm font-semibold text-white">{siteConfig.release.version}</p>
                </div>
                <div>
                  <p className="text-xs text-slate-400 font-medium">File Size</p>
                  <p className="text-sm font-semibold text-white">{siteConfig.release.apkSize}</p>
                </div>
                <div>
                  <p className="text-xs text-slate-400 font-medium">Updated</p>
                  <p className="text-sm font-semibold text-white">{siteConfig.release.releaseDate}</p>
                </div>
                <div>
                  <p className="text-xs text-slate-400 font-medium">OS Compatibility</p>
                  <p className="text-xs font-semibold text-slate-200">{siteConfig.release.minAndroidVersion}</p>
                </div>
                <div>
                  <p className="text-xs text-slate-400 font-medium">Target SDK</p>
                  <p className="text-xs font-semibold text-slate-200">{siteConfig.release.targetSdk}</p>
                </div>
                <div>
                  <p className="text-xs text-slate-400 font-medium">Settlement Layer</p>
                  <p className="text-xs font-semibold text-emerald-400">Solana Devnet</p>
                </div>
              </div>

              {/* SHA-256 Checksum Verification Box */}
              <div className="bg-[#06101E]/80 border border-slate-800 rounded-xl p-3.5 space-y-1.5">
                <div className="flex items-center justify-between text-xs text-slate-400">
                  <span className="flex items-center gap-1.5 font-medium">
                    <ShieldCheck className="w-4 h-4 text-emerald-400" />
                    <span>Verified SHA-256 Checksum</span>
                  </span>
                  <button
                    onClick={handleCopyHash}
                    className="inline-flex items-center gap-1 text-emerald-400 hover:text-emerald-300 font-medium transition-colors"
                  >
                    {copiedHash ? (
                      <>
                        <Check className="w-3.5 h-3.5" />
                        <span>Copied</span>
                      </>
                    ) : (
                      <>
                        <Copy className="w-3.5 h-3.5" />
                        <span>Copy</span>
                      </>
                    )}
                  </button>
                </div>
                <div className="font-mono text-[11px] text-slate-300 break-all select-all">
                  {siteConfig.release.sha256}
                </div>
              </div>
            </div>

            {/* Right: Download Action Box */}
            <div className="lg:col-span-5 flex flex-col justify-center space-y-4 text-center">
              <a
                href={siteConfig.release.apkDownloadUrl}
                download={siteConfig.release.apkFileName}
                className="w-full inline-flex items-center justify-center gap-3 bg-gradient-to-r from-emerald-500 via-emerald-600 to-teal-600 hover:from-emerald-400 hover:to-teal-500 text-white font-bold text-lg px-8 py-5 rounded-2xl shadow-xl shadow-emerald-950/60 hover:shadow-emerald-700/60 hover:-translate-y-0.5 transition-all duration-200"
              >
                <Download className="w-6 h-6 animate-bounce" />
                <span>Download APK ({siteConfig.release.apkSize})</span>
              </a>

              <a
                href={siteConfig.githubUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="w-full inline-flex items-center justify-center gap-2 bg-slate-900/80 hover:bg-slate-900 text-slate-300 hover:text-white font-medium text-sm py-3 rounded-xl border border-slate-700/80 transition-colors"
              >
                <FileCode className="w-4 h-4 text-emerald-400" />
                <span>View Source on GitHub</span>
                <ExternalLink className="w-3.5 h-3.5 text-slate-400" />
              </a>

              <div className="flex items-center justify-center gap-2 text-xs text-slate-400 pt-1">
                <ShieldCheck className="w-4 h-4 text-emerald-400" />
                <span>Malware-free • Official release build</span>
              </div>
            </div>
          </div>

          {/* Sideloading Notice & Disclaimer */}
          <div className="mt-8 pt-6 border-t border-slate-800 text-xs text-slate-400 space-y-2">
            <p className="flex items-start gap-2">
              <AlertCircle className="w-4 h-4 text-amber-400 shrink-0 mt-0.5" />
              <span>
                <strong>Android Sideloading Notice:</strong> Android may prompt "Install unknown apps" permission for your browser. Allow permission only for the downloaded <code className="text-slate-300">{siteConfig.release.apkFileName}</code> obtained from this official portal.
              </span>
            </p>
            <p className="text-[11px] text-slate-500 pl-6">
              * The Solana payment module is configured on Solana Devnet for hackathon demonstration. Devnet transactions represent test tokens and do not constitute real fiat currency transactions.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
};
