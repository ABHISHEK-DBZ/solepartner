import React from 'react';
import { BookOpen, UserX, PackageX, Calculator, AlertTriangle } from 'lucide-react';

export const ProblemSection: React.FC = () => {
  const problems = [
    {
      icon: BookOpen,
      title: "Scattered Paper Registers",
      description:
        "Pages torn, ink faded, or diary misplaced. Manual bahi-khata registers create daily anxiety and make finding past entries nearly impossible.",
      impact: "High risk of record loss & calculation discrepancies",
    },
    {
      icon: UserX,
      title: "Uncollected Customer Udhaar",
      description:
        "Merchants struggle to remember who owes what and for how long. Awkward collection conversations result in delayed payments and cash flow crunches.",
      impact: "Overdue credit directly hurts working capital",
    },
    {
      icon: PackageX,
      title: "Zero Inventory Visibility",
      description:
        "High-demand staples run out without warning, while slow-moving items gather dust on shelves. Stock-outs mean lost daily walk-in customers.",
      impact: "Lost sales during peak retail rush hours",
    },
    {
      icon: Calculator,
      title: "Tedious Nightly Reconciliations",
      description:
        "Spending 1 to 2 hours every night counting cash, adding chits, and guessing net profit instead of resting or growing the retail business.",
      impact: "Hours wasted every evening on mental math",
    },
  ];

  return (
    <section className="py-20 bg-[#071324] relative border-t border-slate-800/80">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-rose-950/40 border border-rose-500/30 text-rose-400 text-xs font-semibold mb-4">
            <AlertTriangle className="w-3.5 h-3.5" />
            <span>The Daily Kirana Challenge</span>
          </div>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white tracking-tight">
            Running a Business Shouldn't Mean{' '}
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-rose-400 to-amber-400">
              Managing Endless Paperwork.
            </span>
          </h2>
          <p className="mt-4 text-base sm:text-lg text-slate-300">
            Traditional Indian retail merchants lose hours every day to manual paperwork and uncollected credit. SolePartner transforms this workflow into effortless voice interactions.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {problems.map((problem, idx) => {
            const Icon = problem.icon;
            return (
              <div
                key={idx}
                className="bg-[#0B172E] border border-slate-800 rounded-2xl p-6 hover:border-slate-700 transition-all duration-200 flex flex-col justify-between"
              >
                <div>
                  <div className="w-12 h-12 rounded-xl bg-rose-500/10 border border-rose-500/20 flex items-center justify-center text-rose-400 mb-5">
                    <Icon className="w-6 h-6" />
                  </div>
                  <h3 className="text-lg font-bold text-white mb-2">{problem.title}</h3>
                  <p className="text-sm text-slate-400 leading-relaxed mb-4">
                    {problem.description}
                  </p>
                </div>
                <div className="pt-3 border-t border-slate-800/80 flex items-center gap-2 text-xs text-rose-400/90 font-medium">
                  <span className="w-1.5 h-1.5 rounded-full bg-rose-500" />
                  <span>{problem.impact}</span>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
};
