const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/auth');
const app = express();

const connectDB = require('./config/db');

// Connect to MongoDB
connectDB();

// Middleware
app.use(cors());
app.use(express.json());

// Test route
app.get('/', (req, res) => {
    res.send('API is running');
});
// Use auth routes
app.use('/api/auth', authRoutes);
// Listen on port 5000
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
