rm .env
cp .env.dev .env
cd android/app
rm google-services.json
cp google-services-development.json google-services.json
cd ../
./gradlew clean
cd ../
flutter clean