const routes = {
    home: '/',
    login: '/login',
    'login.google': '/auth/google',
    logout: '/logout',
    'onboarding.show': '/onboarding',
    'onboarding.store': '/onboarding',
    dashboard: '/dashboard',
    directory: '/directory',
    'profile.personal.update': '/profile/personal',
    'profile.experiences.store': '/profile/experiences',
    'profile.experiences.update': '/profile/experiences/{experience}',
    'profile.experiences.destroy': '/profile/experiences/{experience}',
    'profile.projects.store': '/profile/projects',
    'profile.projects.update': '/profile/projects/{project}',
    'profile.projects.destroy': '/profile/projects/{project}',
    'profile.certificates.store': '/profile/certificates',
    'profile.certificates.update': '/profile/certificates/{certificate}',
    'profile.certificates.destroy': '/profile/certificates/{certificate}',
    'profile.skills.attach': '/profile/skills',
    'profile.skills.suggest': '/profile/skills/suggest',
    'profile.skills.destroy': '/profile/skills/{skill}',
    'profile.availabilities.store': '/profile/availabilities',
    'profile.availabilities.update': '/profile/availabilities/{availability}',
    'profile.availabilities.destroy': '/profile/availabilities/{availability}',
    'admin.dashboard': '/admin/dashboard',
    'admin.users.index': '/admin/users',
    'admin.users.show': '/admin/users/{user}',
    'admin.users.update': '/admin/users/{user}',
    'admin.skills.index': '/admin/skills',
    'admin.skills.approve': '/admin/skills/{skill}/approve',
    'admin.skills.reject': '/admin/skills/{skill}/reject',
    'admin.skills.merge': '/admin/skills/merge',
};

export default function route(name, params) {
    const pattern = routes[name];
    if (!pattern) {
        console.warn(`[route] Unknown route name: "${name}"`);
        return '/';
    }

    if (params == null) return pattern;

    if (typeof params === 'object' && !Array.isArray(params)) {
        const pathParamNames = [...pattern.matchAll(/\{([^}]+)\}/g)].map((m) => m[1]);
        let url = pattern;
        const remainder = { ...params };
        for (const key of pathParamNames) {
            if (remainder[key] != null) {
                url = url.replace(`{${key}}`, encodeURIComponent(String(remainder[key])));
                delete remainder[key];
            }
        }
        const qs = new URLSearchParams(
            Object.fromEntries(Object.entries(remainder).filter(([, v]) => v != null && v !== '')),
        ).toString();
        return qs ? `${url}?${qs}` : url;
    }

    const values = Array.isArray(params) ? params : [params];
    let i = 0;
    return pattern.replace(/\{[^}]+\}/g, () => {
        const val = values[i++];
        return val != null ? encodeURIComponent(val) : '';
    });
}
