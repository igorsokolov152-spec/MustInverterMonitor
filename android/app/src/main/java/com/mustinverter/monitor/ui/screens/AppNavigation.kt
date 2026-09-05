package com.mustinverter.monitor.ui.screens

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController

@Composable
fun AppNavigation() {
    val navController = rememberNavController()
    
    NavHost(
        navController = navController,
        startDestination = "devices"
    ) {
        composable("devices") {
            DevicesListScreen(navController)
        }
        composable("device/{deviceId}") { backStackEntry ->
            val deviceId = backStackEntry.arguments?.getString("deviceId") ?: ""
            DeviceDashboardScreen(navController, deviceId)
        }
        composable("settings") {
            SettingsScreen(navController)
        }
    }
}
