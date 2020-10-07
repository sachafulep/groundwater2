rm .env
cp .env.prod .env
cd android/app
rm google-services.json
cp google-services-production.json google-services.json
cd ../
./gradlew clean
cd ../
flutter clean