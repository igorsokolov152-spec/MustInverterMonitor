package com.mustinverter.monitor.ui.screens

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import com.mustinverter.monitor.data.model.Inverter

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DeviceDashboardScreen(navController: NavHostController, deviceId: String) {
    var device by remember {
        mutableStateOf(
            Inverter(
                id = deviceId,
                name = "Device $deviceId",
                ipAddress = "192.168.1.100",
                voltage = 380.5,
                current = 12.3,
                power = 4680.0,
                temperature = 45.2
            )
        )
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(device.name) },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                }
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text("${device.ipAddress}", style = androidx.compose.material3.MaterialTheme.typography.bodySmall)

            MetricCard(label = "Voltage", value = "${device.voltage}V")
            MetricCard(label = "Current", value = "${device.current}A")
            MetricCard(label = "Power", value = "${device.power}W")
            MetricCard(label = "Temperature", value = "${device.temperature}°C")

            Button(
                onClick = { /* TODO: Refresh data */ },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 16.dp)
            ) {
                Text("Refresh")
            }
        }
    }
}

@Composable
fun MetricCard(label: String, value: String) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(label, style = androidx.compose.material3.MaterialTheme.typography.bodyLarge)
            Text(value, style = androidx.compose.material3.MaterialTheme.typography.bodyLarge)
        }
    }
}
