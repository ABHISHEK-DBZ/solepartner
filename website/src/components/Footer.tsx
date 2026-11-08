import React from 'react';
import { Download, Play, Mail, FileCode } from 'lucide-react';
import { siteConfig } from '../config/site';

export const Footer: React.FC = () => {
  const currentYear = new Date().getFullYear();

  return (
    <footer className="bg-[#040A14] text-slate-400 relative border-t border-slate-800">
      {/* Final Call to Action Banner */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
        <div className="relative rounded-3xl p-8 sm:p-14 bg-gradient-to-r from-emerald-950/80 via-emerald-900/40 to-[#0B1528] border border-emerald-500/30 text-center overflow-hidden">
          <div className="max-w-3xl mx-auto space-y-6 relative z-10">
            <h2 className="text-3xl sm:text-5xl font-extrabold text-white tracking-tight">
              Spend Less Time Managing Records.{' '}
              <span className="text-transparent bg-clip-text bg-gradient-to-r from-emerald-400 to-teal-300">
                Spend More Time Growing Your Business.
              </span>
            </h2>
            <p className="text-base sm:text-lg text-slate-300">
              Download the official Android release today and manage your kirana store with voice, local SQLite speed, and zero math mistakes.
            </p>
            <div className="flex flex-col sm:flex-row items-center justify-center gap-4 pt-2">
              <a
                href="#download"
                className="w-full sm:w-auto inline-flex items-center justify-center gap-3 bg-gradient-to-r from-emerald-500 to-emerald-600 hover:from-emerald-400 hover:to-emerald-500 text-white font-bold text-base px-8 py-4 rounded-2xl shadow-xl shadow-emerald-950 transition-all duration-200"
              >
                <Download className="w-5 h-5" />
                <span>Download SolePartner APK</span>
              </a>
              <a
                href="#demo"
                className="w-full sm:w-auto inline-flex items-center justify-center gap-2 bg-slate-800/80 hover:bg-slate-800 text-white font-medium text-base px-6 py-4 rounded-2xl border border-slate-700 transition-colors"
              >
                <Play className="w-4 h-4 text-emerald-400 fill-emerald-400/30" />
                <span>Explore Product Demo</span>
              </a>
            </div>
          </div>
        </div>
      </div>

      {/* Main Footer Links & Information */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-12">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8 pb-12 border-b border-slate-800/80">
          {/* Brand Info */}
          <div className="md:col-span-2 space-y-4">
            <div className="flex items-center gap-3">
              <div className="w-9 h-9 rounded-xl overflow-hidden border border-emerald-500/30">
                <img
                  src="/images/app_icon.png"
                  alt="SolePartner Logo"
                  className="w-full h-full object-cover"
                />
              </div>
              <span className="text-xl font-bold text-white tracking-tight">
                SolePartner
              </span>
            </div>
            <p className="text-sm text-slate-400 max-w-sm leading-relaxed">
              Your Voice. Your Ledger. Your AI Payment Agent. An autonomous business partner and financial operating system for Indian small businesses and kirana stores.
            </p>
            <div className="flex items-center gap-4 text-sm text-slate-300">
              <a
                href={siteConfig.githubUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="hover:text-emerald-400 flex items-center gap-1.5 transition-colors"
              >
                <FileCode className="w-4 h-4" />
                <span>GitHub Repository</span>
              </a>
              <a
                href={`mailto:${siteConfig.contactEmail}`}
                className="hover:text-emerald-400 flex items-center gap-1.5 transition-colors"
              >
                <Mail className="w-4 h-4" />
                <span>Contact Developer</span>
              </a>
            </div>
          </div>

          {/* Quick Links */}
          <div className="space-y-3">
            <h4 className="text-sm font-semibold text-white uppercase tracking-wider">
              Navigation
            </h4>
            <ul className="space-y-2 text-sm">
              <li>
                <a href="#features" className="hover:text-emerald-400 transition-colors">Features</a>
              </li>
              <li>
                <a href="#how-it-works" className="hover:text-emerald-400 transition-colors">How It Works</a>
              </li>
              <li>
                <a href="#app-preview" className="hover:text-emerald-400 transition-colors">App Preview</a>
              </li>
              <li>
                <a href="#download" className="hover:text-emerald-400 transition-colors">Download APK</a>
              </li>
              <li>
                <a href="#security" className="hover:text-emerald-400 transition-colors">Security Practices</a>
              </li>
              <li>
                <a href="#faq" className="hover:text-emerald-400 transition-colors">FAQ</a>
              </li>
            </ul>
          </div>

          {/* Technology & Compliance */}
          <div className="space-y-3">
            <h4 className="text-sm font-semibold text-white uppercase tracking-wider">
              Architecture
            </h4>
            <ul className="space-y-2 text-sm text-slate-400">
              <li>Flutter 3.x Mobile Client</li>
              <li>Drift SQLite Local Database</li>
              <li>Solana Mobile Wallet Adapter (MWA)</li>
              <li>Solana Devnet Testnet</li>
              <li>Zero Private Key Custody</li>
              <li>100% Offline Core Ledger</li>
            </ul>
          </div>
        </div>

        {/* Bottom Bar */}
        <div className="pt-8 flex flex-col sm:flex-row items-center justify-between text-xs text-slate-400 gap-4">
          <p>© {currentYear} SolePartner. Built for Indian merchants and kirana stores.</p>
          <div className="flex items-center gap-6">
            <a href="#" className="hover:text-emerald-400 transition-colors">Privacy Policy</a>
            <a href="#" className="hover:text-emerald-400 transition-colors">Terms of Service</a>
            <a href={siteConfig.githubUrl} target="_blank" rel="noopener noreferrer" className="hover:text-emerald-400 transition-colors">Open Source</a>
          </div>
        </div>
      </div>
    </footer>
  );
};
