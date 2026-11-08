import React, { useState } from 'react';
import { Smartphone, Mic, BookOpen, Users, Wallet } from 'lucide-react';

export const AppPreviewGallery: React.FC = () => {
  const tabs = [
    {
      id: 'dashboard',
      label: 'Dashboard',
      icon: Smartphone,
      title: 'Real-Time Financial Dashboard',
      description: 'Instant overview of today\'s net sales, cash-in-hand, active udhaar credit, and urgent stock restock alerts.',
      image: '/images/intro_screen.jpg',
      badge: 'Main Hub',
    },
    {
      id: 'voice',
      label: 'Voice Copilot',
      icon: Mic,
      title: 'Voice-Native Bookkeeping',
      description: 'Hands-free transaction recording with audio waveform feedback and real-time natural language slot-filling.',
      image: '/images/intro_artwork.png',
      badge: 'Hindi & English',
    },
    {
      id: 'ledger',
      label: 'Digital Ledger',
      icon: BookOpen,
      title: 'Double-Entry Style Ledger',
      description: 'Clean chronological record of all cash, UPI, credit sales and expenses with zero floating-point math inaccuracies.',
      image: '/images/intro_screen.jpg',
      badge: 'Drift SQLite',
    },
    {
      id: 'customers',
      label: 'Customers & Udhaar',
      icon: Users,
      title: 'Customer Credit Tracking',
      description: 'Manage individual customer limits, overdue repayment timelines, and generate direct 1-tap WhatsApp reminders.',
      image: '/images/intro_artwork.png',
      badge: 'Credit Health',
    },
    {
      id: 'wallet',
      label: 'Solana Wallet',
      icon: Wallet,
      title: 'Self-Custodial Solana Mobile Wallet Adapter',
      description: 'Connect Phantom or Solflare wallets on Android for Devnet demonstration with zero private key custody.',
      image: '/images/intro_screen.jpg',
      badge: 'Devnet Testnet',
    },
  ];

  const [activeTab, setActiveTab] = useState(tabs[0].id);
  const currentTab = tabs.find((t) => t.id === activeTab) || tabs[0];

  return (
    <section id="app-preview" className="py-24 bg-[#06101E] relative">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-14">
          <span className="text-xs font-semibold uppercase tracking-wider text-emerald-400 bg-emerald-950/60 border border-emerald-500/30 px-3.5 py-1.5 rounded-full">
            Application Screenshots & UI Walkthrough
          </span>
          <h2 className="mt-4 text-3xl sm:text-5xl font-extrabold text-white tracking-tight">
            Take a Look Inside{' '}
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-emerald-400 to-teal-300">
              SolePartner.
            </span>
          </h2>
          <p className="mt-3 text-base text-slate-300">
            A production fintech interface designed for clarity, high contrast, and smooth micro-interactions.
          </p>
        </div>

        {/* Tab Buttons */}
        <div className="flex items-center justify-start sm:justify-center gap-2 overflow-x-auto pb-4 mb-10 no-scrollbar">
          {tabs.map((tab) => {
            const Icon = tab.icon;
            const isActive = tab.id === activeTab;
            return (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`flex items-center gap-2 px-4 py-2.5 rounded-xl font-medium text-sm whitespace-nowrap transition-all duration-200 border ${
                  isActive
                    ? 'bg-emerald-600 text-white border-emerald-500 shadow-md shadow-emerald-950'
                    : 'bg-[#0B1528] text-slate-300 border-slate-800 hover:border-slate-700 hover:text-white'
                }`}
              >
                <Icon className={`w-4 h-4 ${isActive ? 'text-white' : 'text-emerald-400'}`} />
                <span>{tab.label}</span>
              </button>
            );
          })}
        </div>

        {/* Tab Content Display */}
        <div className="bg-[#0B1528] border border-slate-800 rounded-3xl p-6 sm:p-10 shadow-2xl shadow-emerald-950/30">
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
            {/* Description Column */}
            <div className="lg:col-span-6 space-y-4 text-left">
              <span className="inline-block text-xs font-semibold uppercase tracking-wider text-emerald-400 bg-emerald-950/60 border border-emerald-500/30 px-2.5 py-1 rounded-md">
                {currentTab.badge}
              </span>
              <h3 className="text-2xl sm:text-3xl font-bold text-white tracking-tight">
                {currentTab.title}
              </h3>
              <p className="text-base text-slate-300 leading-relaxed">
                {currentTab.description}
              </p>
              
              <div className="pt-4 border-t border-slate-800 space-y-3">
                <div className="flex items-center gap-2 text-sm text-slate-200 font-medium">
                  <span className="w-2 h-2 rounded-full bg-emerald-400" />
                  <span>Pixel-perfect high-contrast fintech design tokens</span>
                </div>
                <div className="flex items-center gap-2 text-sm text-slate-200 font-medium">
                  <span className="w-2 h-2 rounded-full bg-emerald-400" />
                  <span>Interactive light/dark animated theme switching</span>
                </div>
                <div className="flex items-center gap-2 text-sm text-slate-200 font-medium">
                  <span className="w-2 h-2 rounded-full bg-emerald-400" />
                  <span>Built for Android 8.0 through Android 14+ devices</span>
                </div>
              </div>
            </div>

            {/* Mockup / Image Column */}
            <div className="lg:col-span-6 flex justify-center">
              <div className="relative max-w-[280px] sm:max-w-[300px] rounded-[32px] p-2 bg-gradient-to-b from-slate-700 to-slate-900 border border-slate-700/60 shadow-2xl">
                <div className="rounded-[26px] overflow-hidden bg-slate-950 aspect-[9/19] border border-slate-800">
                  <img
                    src={currentTab.image}
                    alt={currentTab.title}
                    className="w-full h-full object-cover transition-opacity duration-300"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};
