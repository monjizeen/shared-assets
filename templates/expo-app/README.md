# Expo app template (org conventions)

Maintained overlay for `scaffold-expo.sh`. When empty, the script falls back to `create-expo-app` + Lucide.

## Stack

- Expo + TypeScript
- `lucide-react-native` for icons
- `constants/theme.ts` for shared tokens (not shadcn — web-only)

## Optional

Add a committed `package.json` here to pin Expo SDK version for all new mobile projects.
