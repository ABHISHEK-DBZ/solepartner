import React, { useState } from 'react';
import { ChevronDown } from 'lucide-react';

export const FAQ: React.FC = () => {
  const [openIdx, setOpenIdx] = useState<number | null>(0);

  const faqs = [
    {
      q: "What is SolePartner?",
      a: "SolePartner is an offline-first, voice-native business and financial operating system built specifically for Indian kirana stores, retailers, and small shopkeepers. It combines voice bookkeeping, digital khata ledger, customer udhaar tracking, inventory management, and zero-trust Solana payments into one intuitive Android app.",
    },
    {
      q: "Who can use SolePartner?",
      a: "Any retail shopkeeper, grocery owner, distributor, or small business merchant. The interface is optimized for daily high-traffic retail counters with large text, high contrast, and voice-to-text input in Hindi, Hinglish, and English.",
    },
    {
      q: "How do I download and install the Android APK?",
      a: "Tap the 'Download APK' button on this website to save SolePartner-Android.apk. Open the downloaded file on your Android smartphone. If prompted, toggle 'Allow installation from this source' in your Android settings, then tap Install. The app works on Android 8.0 through Android 14+.",
    },
    {
      q: "Does SolePartner work offline?",
      a: "Yes! The core ledger, customer khata, product inventory, and daily calculations use an embedded SQLite database (via Drift) on your device. You can add sales, check customer credit, and record expenses completely offline without an internet connection.",
    },
    {
      q: "Can I manage customer Udhaar (credit)?",
      a: "Absolutely. You can set custom credit limits for each customer, see overdue days highlighted in color, record partial or full repayments, and send one-tap formatted WhatsApp payment reminder messages.",
    },
    {
      q: "Does SolePartner support voice commands?",
      a: "Yes. Hold the microphone button and speak naturally (e.g. 'Aaj Ramesh ko 5,000 ka udhaar diya' or 'Shop rent 12,000 cash me add karo'). The parser extracts the transaction details and presents a visual preview for your confirmation.",
    },
    {
      q: "What is Solana Devnet?",
      a: "Solana Devnet is an official test network used by developers to test smart contracts and transactions without risking real money. SolePartner connects to Solana Devnet via Mobile Wallet Adapter (Phantom / Solflare) for hackathon demonstration.",
    },
    {
      q: "Are Devnet transactions real payments?",
      a: "No. Solana Devnet uses test tokens (test SOL) that have no real monetary value. This allows you to experience fast 400ms cryptographic settlement and signature verification safely in a risk-free testing environment.",
    },
    {
      q: "Is SolePartner free to use?",
      a: "Yes. SolePartner is free to download and explore. There are no subscriptions, lock-ins, or intrusive advertisements.",
    },
  ];

  return (
    <section id="faq" className="py-24 bg-[#06101E] relative">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-14">
          <span className="text-xs font-semibold uppercase tracking-wider text-emerald-400 bg-emerald-950/60 border border-emerald-500/30 px-3.5 py-1.5 rounded-full">
            Got Questions?
          </span>
          <h2 className="mt-4 text-3xl sm:text-4xl font-extrabold text-white tracking-tight">
            Frequently Asked Questions
          </h2>
          <p className="mt-3 text-base text-slate-300">
            Clear, honest answers about SolePartner's features, offline architecture, and installation.
          </p>
        </div>

        <div className="space-y-4">
          {faqs.map((faq, idx) => {
            const isOpen = openIdx === idx;
            return (
              <div
                key={idx}
                className="bg-[#0B1528] border border-slate-800 rounded-2xl overflow-hidden transition-colors"
              >
                <button
                  onClick={() => setOpenIdx(isOpen ? null : idx)}
                  className="w-full flex items-center justify-between p-6 text-left focus:outline-none"
                >
                  <span className="font-semibold text-white text-base sm:text-lg pr-4">
                    {faq.q}
                  </span>
                  <ChevronDown
                    className={`w-5 h-5 text-emerald-400 shrink-0 transition-transform duration-200 ${
                      isOpen ? 'rotate-180 text-emerald-300' : ''
                    }`}
                  />
                </button>
                {isOpen && (
                  <div className="px-6 pb-6 text-slate-300 text-sm sm:text-base leading-relaxed border-t border-slate-800/80 pt-4">
                    {faq.a}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
};
