# Because the app sits in it's own network, we need to forward the host's port 8080 (where the backend is on) to the Android emulator (VM) so we can use the backend
adb reverse tcp:8080 tcp:8080