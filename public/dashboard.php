<?php
session_start();
require_once __DIR__ . '/../src/app.php';
if (!isset($_SESSION['username'])) {
    header("Location: login.php");
    exit;
}
$username = $_SESSION['username'];
$washes = getUserWashes($username);
include __DIR__ . '/../templates/header.php';
?>
<h2>Welcome, <?php echo htmlspecialchars($username); ?></h2>
<a href="add_wash.php">Add Wash</a> | <a href="logout.php">Logout</a>
<h3>Your Wash Records</h3>
<ul>
<?php foreach ($washes as $wash): ?>
    <li><?php echo htmlspecialchars($wash['date']) . " - " . htmlspecialchars($wash['type']); ?></li>
<?php endforeach; ?>
</ul>
<?php include __DIR__ . '/../templates/footer.php'; ?>
