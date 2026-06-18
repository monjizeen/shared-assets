<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { LayoutDashboard } from 'lucide-vue-next';
import { usePage } from '@inertiajs/vue3';
import { computed } from 'vue';

const user = computed(() => usePage().props.auth?.user);
</script>

<template>
    <AppLayout>
        <Card>
            <CardHeader>
                <CardTitle class="flex items-center gap-2">
                    <LayoutDashboard class="size-5" />
                    Dashboard
                </CardTitle>
                <CardDescription>Signed in as {{ user?.email }}</CardDescription>
            </CardHeader>
            <CardContent>
                <p class="text-muted-foreground text-sm">Replace this shell with your product UI.</p>
            </CardContent>
        </Card>
    </AppLayout>
</template>
