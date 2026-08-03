const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const rootDir = __dirname;
const webDir = path.join(rootDir, 'rheo-web');
const appAssetsDir = path.join(rootDir, 'rheo_app', 'assets', 'journey-web');

console.log('🚀 Starting Build & Sync Process...');

try {
  // 1. Build the web journey
  console.log('📦 Building React Web Journey...');
  execSync('npm run build', { cwd: webDir, stdio: 'inherit' });
  console.log('✅ React Web Journey built successfully.');

  // 2. Clean and recreate the target assets directory in Flutter
  console.log(`🧹 Cleaning target directory: ${appAssetsDir}...`);
  if (fs.existsSync(appAssetsDir)) {
    fs.rmSync(appAssetsDir, { recursive: true, force: true });
  }
  fs.mkdirSync(appAssetsDir, { recursive: true });

  // 3. Copy dist/ files to Flutter assets recursively
  const distDir = path.join(webDir, 'dist');
  console.log(`📥 Copying files from ${distDir} to ${appAssetsDir}...`);
  fs.cpSync(distDir, appAssetsDir, { recursive: true });
  console.log('✅ Files copied successfully.');

  console.log('🎉 Build & Sync completed successfully!');
} catch (error) {
  console.error('❌ Build & Sync failed:', error.message);
  process.exit(1);
}
