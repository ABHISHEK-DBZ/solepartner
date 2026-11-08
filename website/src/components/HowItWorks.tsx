import React from 'react';
import { Download, Store, Mic, LayoutDashboard } from 'lucide-react';

export const HowItWorks: React.FC = () => {
  const steps = [
    {
      number: "01",
      icon: Download,
      title: "Download SolePartner",
      description: "Get the Android APK directly from our official portal. Install without ads or subscription barriers.",
    },
    {
      number: "02",
      icon: Store,
      title: "Create Shop Profile",
      description: "Set your store name, preferred language (English or Hindi), and initial inventory items in under 60 seconds.",
    },
    {
      number: "03",
      icon: Mic,
      title: "Speak Your Transactions",
      description: "Hold the microphone button and speak sales or udhaar naturally. Review the auto-extracted transaction preview.",
    },
    {
      number: "04",
      icon: LayoutDashboard,
      title: "Grow With Smart Insights",
      description: "Monitor daily net revenue, track overdue credit collections, and reorder low-stock items with confidence.",
    },
  ];

  return (
    <section id="how-it-works" className="py-24 bg-[#071324] relative border-t border-slate-800/80">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <span className="text-xs font-semibold uppercase tracking-wider text-emerald-400 bg-emerald-950/60 border border-emerald-500/30 px-3 py-1 rounded-full">
            Quick 4-Step Onboarding
          </span>
          <h2 className="mt-4 text-3xl sm:text-4xl font-extrabold text-white tracking-tight">
            How SolePartner Works in Your Store
          </h2>
          <p className="mt-3 text-base text-slate-300">
            Zero complicated training required. Designed for immediate productivity on any Android device.
          </p>
        </div>

        {/* Steps Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 relative">
          {steps.map((step, idx) => {
            const Icon = step.icon;
            return (
              <div key={idx} className="relative flex flex-col items-center text-center group">
                {/* Step Circle */}
                <div className="relative mb-6">
                  <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-emerald-500/20 to-teal-500/10 border border-emerald-500/30 flex items-center justify-center text-emerald-400 group-hover:scale-110 group-hover:border-emerald-400 transition-all shadow-lg shadow-emerald-950/40">
                    <Icon className="w-7 h-7" />
                  </div>
                  <span className="absolute -top-2 -right-2 bg-emerald-500 text-slate-950 text-xs font-extrabold w-6 h-6 rounded-full flex items-center justify-center shadow-md">
                    {idx + 1}
                  </span>
                </div>

                <h3 className="text-lg font-bold text-white mb-2">{step.title}</h3>
                <p className="text-sm text-slate-400 leading-relaxed max-w-xs">{step.description}</p>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
};

