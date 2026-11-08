import React, { useState } from 'react';
import { Play, Clock } from 'lucide-react';
import { siteConfig } from '../config/site';

export const DemoVideo: React.FC = () => {
  const [isPlaying, setIsPlaying] = useState(false);

  return (
    <section id="demo" className="py-24 bg-[#071324] relative border-t border-slate-800/80">
      <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-14">
          <span className="text-xs font-semibold uppercase tracking-wider text-emerald-400 bg-emerald-950/60 border border-emerald-500/30 px-3.5 py-1.5 rounded-full">
            Product Walkthrough
          </span>
          <h2 className="mt-4 text-3xl sm:text-4xl font-extrabold text-white tracking-tight">
            See SolePartner in Action
          </h2>
          <p className="mt-3 text-base text-slate-300">
            Watch how a kirana merchant adds voice transactions, manages customer udhaar, and settles supplier payments on Android.
          </p>
        </div>

        {/* Video Player or Polished Placeholder Container */}
        <div className="relative rounded-3xl overflow-hidden border border-slate-800 bg-[#0B1528] shadow-2xl shadow-emerald-950/40 aspect-video flex items-center justify-center group">
          {siteConfig.demoVideoUrl && isPlaying ? (
            <iframe
              className="w-full h-full"
              src={`${siteConfig.demoVideoUrl}?autoplay=1`}
              title="SolePartner Demo Video"
              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
              allowFullScreen
            />
          ) : (
            <div className="relative w-full h-full flex flex-col items-center justify-center p-6 text-center">
              {/* Background poster art with subtle dark overlay */}
              <img
                src="/images/intro_artwork.png"
                alt="Demo Poster Thumbnail"
                className="absolute inset-0 w-full h-full object-cover opacity-20 filter blur-sm group-hover:scale-105 transition-transform duration-700"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-[#0B1528] via-[#0B1528]/80 to-transparent" />

              {/* Interactive Center Play Action / Notification */}
              <div className="relative z-10 max-w-md space-y-4">
                <div className="w-20 h-20 mx-auto rounded-3xl bg-gradient-to-tr from-emerald-600 to-teal-400 flex items-center justify-center text-white shadow-xl shadow-emerald-900/60 group-hover:scale-110 transition-transform cursor-pointer">
                  <Play className="w-8 h-8 fill-white ml-1" />
                </div>

                <div className="space-y-2">
                  <span className="inline-flex items-center gap-1.5 text-xs font-semibold text-emerald-400 bg-emerald-950/80 border border-emerald-500/30 px-3 py-1 rounded-full">
                    <Clock className="w-3.5 h-3.5" />
                    <span>Live 3-Minute Walkthrough Video</span>
                  </span>
                  <h3 className="text-xl sm:text-2xl font-bold text-white">
                    SolePartner Kirana Walkthrough
                  </h3>
                  <p className="text-sm text-slate-300 leading-relaxed">
                    Voice ledger command parsing, Drift SQLite offline storage, and Solana Devnet MWA signature approval workflow.
                  </p>
                </div>

                {siteConfig.demoVideoUrl ? (
                  <button
                    onClick={() => setIsPlaying(true)}
                    className="inline-flex items-center gap-2 bg-emerald-600 hover:bg-emerald-500 text-white font-semibold text-sm px-6 py-2.5 rounded-xl shadow-md transition-all"
                  >
                    <span>Play Demo Video</span>
                  </button>
                ) : (
                  <div className="pt-2">
                    <span className="text-xs text-slate-400 bg-slate-900/90 border border-slate-800 px-3.5 py-1.5 rounded-lg inline-block">
                      Official YouTube demo video release linking soon • Download APK below to test locally
                    </span>
                  </div>
                )}
              </div>
            </div>
          )}
        </div>
      </div>
    </section>
  );
};
