import React from 'react';
import { Navbar } from './components/Navbar';
import { HeroSection } from './components/HeroSection';
import { ProblemSection } from './components/ProblemSection';
import { FeaturesSection } from './components/FeaturesSection';
import { HowItWorks } from './components/HowItWorks';
import { AppPreviewGallery } from './components/AppPreviewGallery';
import { DemoVideo } from './components/DemoVideo';
import { APKDownloadCard } from './components/APKDownloadCard';
import { SecuritySection } from './components/SecuritySection';
import { FAQ } from './components/FAQ';
import { Footer } from './components/Footer';

export const App: React.FC = () => {
  return (
    <div className="min-h-screen bg-[#06101E] text-slate-100 flex flex-col font-sans">
      <Navbar />
      <main className="flex-grow">
        <HeroSection />
        <ProblemSection />
        <FeaturesSection />
        <HowItWorks />
        <AppPreviewGallery />
        <DemoVideo />
        <APKDownloadCard />
        <SecuritySection />
        <FAQ />
      </main>
      <Footer />
    </div>
  );
};

export default App;
