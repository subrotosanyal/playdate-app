const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const router = express.Router();

// Mock user database (you can replace this with a proper database like MongoDB)
const users = [];

// Signup route
router.post('/signup', async (req, res) => {
    const { email, password } = req.body;

    // Check if user exists
    const userExists = users.find((user) => user.email === email);
    if (userExists) {
        return res.status(400).json({ msg: 'User already exists' });
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create a new user
    const newUser = { email, password: hashedPassword };
    users.push(newUser);

    // Return success message
    res.json({ msg: 'User registered successfully' });
});

// Login route
router.post('/login', async (req, res) => {
    const { email, password } = req.body;

    // Check if user exists
    const user = users.find((user) => user.email === email);
    if (!user) {
        return res.status(400).json({ msg: 'Invalid email or password' });
    }

    // Compare password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
        return res.status(400).json({ msg: 'Invalid email or password' });
    }

    // Create JWT token
    const token = jwt.sign({ email: user.email }, process.env.JWT_SECRET, { expiresIn: '1h' });

    // Return the token
    res.json({ token });
});

module.exports = router;
