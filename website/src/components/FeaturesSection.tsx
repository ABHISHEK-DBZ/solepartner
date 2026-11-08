import React from 'react';
import { Mic, BookCheck, Users, Boxes, TrendingUp, Sparkles, Wallet, Database, CheckCircle2 } from 'lucide-react';

export const FeaturesSection: React.FC = () => {
  const features = [
    {
      icon: Mic,
      title: "Voice Bookkeeping",
      badge: "Voice-Native",
      badgeColor: "bg-emerald-500/10 text-emerald-400 border-emerald-500/30",
      description:
        "Speak naturally in Hindi, Hinglish, or English. SolePartner extracts transaction types, amounts, and customer names with deterministic slot-filling validation.",
      bulletPoints: ["Supports natural dialects", "Instant verbal confirmation", "Hands-free operation"],
    },
    {
      icon: BookCheck,
      title: "Smart Digital Ledger",
      badge: "Double-Entry Rigor",
      badgeColor: "bg-teal-500/10 text-teal-400 border-teal-500/30",
      description:
        "Clean transaction history categorized into Sales, Expenses, and Credit. Track cash on hand and daily gross margin with zero math errors.",
      bulletPoints: ["Pure integer paise arithmetic", "Filter by date and category", "Full audit trail"],
    },
    {
      icon: Users,
      title: "Customer Udhaar Management",
      badge: "Credit Recovery",
      badgeColor: "bg-amber-500/10 text-amber-400 border-amber-500/30",
      description:
        "Track individual customer credit limits, payment history, and overdue timelines. Generate gentle WhatsApp payment reminder messages in one tap.",
      bulletPoints: ["Custom credit limits", "Overdue status badges", "1-Tap WhatsApp reminders"],
    },
    {
      icon: Boxes,
      title: "Inventory & Stock Control",
      badge: "Barcode Ready",
      badgeColor: "bg-blue-500/10 text-blue-400 border-blue-500/30",
      description:
        "Real-time product catalog with SKU, barcodes, purchase costs, and retail prices. Automated stock decrement with proactive restock notifications.",
      bulletPoints: ["Live stock counters", "Low-stock reorder alerts", "Fast barcode scanning"],
    },
    {
      icon: TrendingUp,
      title: "AI Business Insights",
      badge: "Local Intelligence",
      badgeColor: "bg-purple-500/10 text-purple-400 border-purple-500/30",
      description:
        "Actionable summaries delivered daily: top-selling grocery items, weekly profit trends, and capital locked in overdue customer credit.",
      bulletPoints: ["Daily profit analysis", "Dead stock detection", "Working capital forecasts"],
    },
    {
      icon: Sparkles,
      title: "AI-Assisted Payments",
      badge: "Zero-Trust Safety",
      badgeColor: "bg-emerald-500/10 text-emerald-400 border-emerald-500/30",
      description:
        "AI suggests draft payments to registered suppliers. LLMs are strictly forbidden from signing or authorizing money without biometric owner approval.",
      bulletPoints: ["Explicit merchant confirmation", "Daily spending caps", "Whitelisted payees only"],
    },
    {
      icon: Wallet,
      title: "Solana Wallet Integration",
      badge: "Devnet Testnet",
      badgeColor: "bg-cyan-500/10 text-cyan-400 border-cyan-500/30",
      description:
        "Connect self-custodial Phantom or Solflare mobile wallets via Mobile Wallet Adapter (MWA). Tested on Solana Devnet with pre-submission wire verification.",
      bulletPoints: ["Zero private key custody", "Sub-second block finality", "Devnet testnet demonstration"],
    },
    {
      icon: Database,
      title: "Offline-First SQLite Architecture",
      badge: "100% Offline Core",
      badgeColor: "bg-emerald-500/10 text-emerald-400 border-emerald-500/30",
      description:
        "All ledger entries, inventory items, and customer balances are saved directly to local Drift SQLite. Never halts when the internet goes down.",
      bulletPoints: ["Works in zero connectivity", "Instant local queries", "Private on-device storage"],
    },
  ];

  return (
    <section id="features" className="py-24 bg-[#06101E] relative">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-emerald-950/50 border border-emerald-500/30 text-emerald-400 text-xs font-semibold mb-4">
            <Sparkles className="w-3.5 h-3.5 text-amber-400" />
            <span>Complete Business Operating System</span>
          </div>
          <h2 className="text-3xl sm:text-5xl font-extrabold text-white tracking-tight">
            Meet Your New{' '}
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-emerald-400 via-teal-300 to-emerald-500">
              AI Business Partner.
            </span>
          </h2>
          <p className="mt-4 text-base sm:text-lg text-slate-300">
            Engineered from the ground up for Indian small business owners. Every feature combines offline reliability with modern AI assistance.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {features.map((feature, idx) => {
            const Icon = feature.icon;
            return (
              <div
                key={idx}
                className="bg-[#0B1528] border border-slate-800/80 rounded-2xl p-6 hover:border-emerald-500/40 hover:shadow-xl hover:shadow-emerald-950/20 transition-all duration-300 flex flex-col justify-between group"
              >
                <div>
                  <div className="flex items-center justify-between mb-5">
                    <div className="w-12 h-12 rounded-xl bg-emerald-500/10 border border-emerald-500/20 flex items-center justify-center text-emerald-400 group-hover:scale-105 group-hover:border-emerald-400 transition-all">
                      <Icon className="w-6 h-6" />
                    </div>
                    <span className={`text-[10px] font-semibold uppercase tracking-wider px-2 py-0.5 rounded-md border ${feature.badgeColor}`}>
                      {feature.badge}
                    </span>
                  </div>

                  <h3 className="text-lg font-bold text-white mb-2 group-hover:text-emerald-300 transition-colors">
                    {feature.title}
                  </h3>
                  <p className="text-sm text-slate-400 leading-relaxed mb-5">
                    {feature.description}
                  </p>
                </div>

                <div className="pt-4 border-t border-slate-800/80 space-y-2">
                  {feature.bulletPoints.map((point, pIdx) => (
                    <div key={pIdx} className="flex items-center gap-2 text-xs text-slate-300 font-medium">
                      <CheckCircle2 className="w-3.5 h-3.5 text-emerald-400 shrink-0" />
                      <span>{point}</span>
                    </div>
                  ))}
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
};
