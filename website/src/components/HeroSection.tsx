import React from 'react';
import { Download, Play, Mic, ShieldCheck, WifiOff, Sparkles, CheckCircle2 } from 'lucide-react';
import { siteConfig } from '../config/site';

export const HeroSection: React.FC = () => {
  return (
    <section className="relative pt-32 pb-20 md:pt-40 md:pb-28 overflow-hidden">
      {/* Background radial glow */}
      <div className="absolute top-1/4 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] bg-emerald-600/15 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute top-20 right-10 w-72 h-72 bg-emerald-500/10 rounded-full blur-2xl pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-8 items-center">
          {/* Left Column: Messaging */}
          <div className="lg:col-span-7 space-y-6 text-center lg:text-left">
            {/* Pill Badge */}
            <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-emerald-950/60 border border-emerald-500/30 text-emerald-400 text-xs font-semibold tracking-wide">
              <Sparkles className="w-3.5 h-3.5 text-amber-400" />
              <span>Offline-First • Voice-Native • Solana Settlement</span>
            </div>

            {/* Main Headline */}
            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-extrabold text-white tracking-tight leading-[1.15]">
              Your Business Deserves an{' '}
              <span className="text-transparent bg-clip-text bg-gradient-to-r from-emerald-400 via-teal-300 to-emerald-500">
                AI Partner.
              </span>
            </h1>

            {/* Supporting Copy */}
            <p className="text-lg sm:text-xl text-slate-300 max-w-2xl mx-auto lg:mx-0 font-normal leading-relaxed">
              Manage sales, expenses, inventory, customer credit (Udhaar), and payments — all through one intelligent, voice-first business companion built for Indian merchants.
            </p>

            {/* CTAs */}
            <div className="flex flex-col sm:flex-row items-center justify-center lg:justify-start gap-4 pt-2">
              <a
                href="#download"
                className="w-full sm:w-auto inline-flex items-center justify-center gap-3 bg-gradient-to-r from-emerald-600 via-emerald-500 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-semibold text-base px-7 py-3.5 rounded-2xl shadow-xl shadow-emerald-950/50 hover:shadow-emerald-700/50 hover:-translate-y-0.5 transition-all duration-200"
              >
                <Download className="w-5 h-5" />
                <span>Download Android App</span>
                <span className="text-xs bg-emerald-900/60 px-2 py-0.5 rounded-full border border-emerald-400/30">
                  {siteConfig.release.apkSize}
                </span>
              </a>

              <a
                href="#demo"
                className="w-full sm:w-auto inline-flex items-center justify-center gap-2.5 bg-slate-800/80 hover:bg-slate-800 text-slate-200 hover:text-white font-medium text-base px-6 py-3.5 rounded-2xl border border-slate-700 hover:border-slate-600 transition-all duration-200"
              >
                <Play className="w-4 h-4 text-emerald-400 fill-emerald-400/30" />
                <span>Watch Product Demo</span>
              </a>
            </div>

            {/* Trust Badges */}
            <div className="pt-6 border-t border-slate-800/80 grid grid-cols-3 gap-4 text-center lg:text-left">
              <div className="flex items-center justify-center lg:justify-start gap-2 text-slate-300 text-xs sm:text-sm font-medium">
                <Mic className="w-4 h-4 text-emerald-400 shrink-0" />
                <span>Voice-First (Hindi/English)</span>
              </div>
              <div className="flex items-center justify-center lg:justify-start gap-2 text-slate-300 text-xs sm:text-sm font-medium">
                <WifiOff className="w-4 h-4 text-emerald-400 shrink-0" />
                <span>100% Offline SQLite</span>
              </div>
              <div className="flex items-center justify-center lg:justify-start gap-2 text-slate-300 text-xs sm:text-sm font-medium">
                <ShieldCheck className="w-4 h-4 text-emerald-400 shrink-0" />
                <span>Zero-Trust Payments</span>
              </div>
            </div>
          </div>

          {/* Right Column: Phone Mockup / Artwork */}
          <div className="lg:col-span-5 flex justify-center relative">
            <div className="relative mx-auto max-w-[320px] sm:max-w-[340px]">
              {/* Phone Frame Device Styling */}
              <div className="relative rounded-[40px] p-3 bg-gradient-to-b from-slate-700 via-slate-800 to-slate-900 shadow-2xl shadow-emerald-950/60 border border-slate-700/60">
                {/* Speaker Notch */}
                <div className="absolute top-6 left-1/2 -translate-x-1/2 w-20 h-4 bg-slate-950 rounded-full z-20" />
                
                {/* Screen Container */}
                <div className="relative rounded-[32px] overflow-hidden bg-[#0B1528] aspect-[9/19.5] border border-slate-800">
                  <img
                    src="/images/intro_screen.jpg"
                    alt="SolePartner App Preview"
                    className="w-full h-full object-cover"
                    onError={(e) => {
                      (e.target as HTMLImageElement).src = '/images/intro_artwork.png';
                    }}
                  />
                  {/* Subtle Gradient Overlay */}
                  <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent pointer-events-none" />
                </div>
              </div>

              {/* Floating Highlight Card 1 */}
              <div className="absolute -bottom-6 -left-6 sm:-left-10 bg-[#0B1528]/95 backdrop-blur-md border border-emerald-500/30 p-3.5 rounded-2xl shadow-xl shadow-black/50 hidden sm:flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-emerald-500/20 flex items-center justify-center text-emerald-400">
                  <Mic className="w-5 h-5" />
                </div>
                <div>
                  <p className="text-xs text-slate-400">Voice Bookkeeping</p>
                  <p className="text-sm font-semibold text-white">"Aaj 5,000 ka sales add karo"</p>
                </div>
              </div>

              {/* Floating Highlight Card 2 */}
              <div className="absolute -top-4 -right-6 sm:-right-8 bg-[#0B1528]/95 backdrop-blur-md border border-emerald-500/30 p-3 rounded-2xl shadow-xl shadow-black/50 hidden sm:flex items-center gap-2.5">
                <div className="w-8 h-8 rounded-lg bg-emerald-500/20 flex items-center justify-center text-emerald-400">
                  <CheckCircle2 className="w-4 h-4" />
                </div>
                <div>
                  <p className="text-[11px] text-slate-400">Solana Devnet</p>
                  <p className="text-xs font-bold text-emerald-400">Non-Custodial MWA</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};
