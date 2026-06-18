<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { LogIn } from 'lucide-vue-next';
import { Link, usePage } from '@inertiajs/vue3';
import { computed } from 'vue';

const user = computed(() => usePage().props.auth?.user);
</script>

<template>
    <AppLayout>
        <Card class="mx-auto max-w-lg">
            <CardHeader>
                <CardTitle>Welcome</CardTitle>
                <CardDescription>Org web app scaffold with shadcn-vue and Lucide icons.</CardDescription>
            </CardHeader>
            <CardContent class="flex flex-wrap gap-3">
                <Button v-if="user" as-child>
                    <Link :href="route('dashboard')">Open dashboard</Link>
                </Button>
                <Button v-else as-child>
                    <Link :href="route('login')">
                        <LogIn class="size-4" />
                        Sign in
                    </Link>
                </Button>
            </CardContent>
        </Card>
    </AppLayout>
</template>
