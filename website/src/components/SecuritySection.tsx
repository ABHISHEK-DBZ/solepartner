import React from 'react';
import { ShieldCheck, UserCheck, KeyRound, Database, History, EyeOff } from 'lucide-react';

export const SecuritySection: React.FC = () => {
  const securityPillars = [
    {
      icon: UserCheck,
      title: "Owner-Controlled Approval",
      description: "AI assists with transaction preparation and draft proposals, but can never initiate or finalize a payment without explicit merchant biometric or PIN confirmation.",
    },
    {
      icon: EyeOff,
      title: "Zero Private Key Custody",
      description: "SolePartner never requests, stores, or handles your seed phrases or private keys. All cryptographic signing occurs inside your installed mobile wallet (Phantom / Solflare).",
    },
    {
      icon: KeyRound,
      title: "Pre-Submission Wire Verification",
      description: "Every signed wire payload is decoded and cryptographically verified on-device (SignedTx.fromBytes) prior to RPC submission to guarantee target addresses haven't been tampered with.",
    },
    {
      icon: Database,
      title: "Offline-First Local Storage",
      description: "Your daily sales, expenses, and customer credit ledger records live in your device's local SQLite database. Core operations do not rely on remote servers or cloud connectivity.",
    },
    {
      icon: ShieldCheck,
      title: "Deterministic Spending Policies",
      description: "Strict on-device rules enforce maximum single-payment amounts (0.1 SOL cap) and daily velocity limits (1.0 SOL) with whitelist validation for registered payees.",
    },
    {
      icon: History,
      title: "Immutable Double-Entry Ledger",
      description: "Every financial event is recorded with non-destructive debit/credit balance tracking and a complete audit log, ensuring verifiable math and zero record loss.",
    },
  ];

  return (
    <section id="security" className="py-24 bg-[#071324] relative border-t border-slate-800/80">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <span className="text-xs font-semibold uppercase tracking-wider text-emerald-400 bg-emerald-950/60 border border-emerald-500/30 px-3.5 py-1.5 rounded-full">
            Security Architecture & Data Privacy
          </span>
          <h2 className="mt-4 text-3xl sm:text-4xl font-extrabold text-white tracking-tight">
            Your Business Data{' '}
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-emerald-400 to-teal-300">
              Deserves Protection.
            </span>
          </h2>
          <p className="mt-3 text-base text-slate-300">
            Engineered with strict zero-trust invariants. No simulated transactions, no silent authorizations, and zero private key risk.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {securityPillars.map((pillar, idx) => {
            const Icon = pillar.icon;
            return (
              <div
                key={idx}
                className="bg-[#0B172E] border border-slate-800 rounded-2xl p-6 hover:border-slate-700 transition-all duration-200"
              >
                <div className="w-12 h-12 rounded-xl bg-emerald-500/10 border border-emerald-500/20 flex items-center justify-center text-emerald-400 mb-5">
                  <Icon className="w-6 h-6" />
                </div>
                <h3 className="text-lg font-bold text-white mb-2">{pillar.title}</h3>
                <p className="text-sm text-slate-400 leading-relaxed">
                  {pillar.description}
                </p>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
};
