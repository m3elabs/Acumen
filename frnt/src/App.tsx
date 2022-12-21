import { useEffect, useState } from "react";
import { TAI64 } from "tai64";
import { Wallet, BN, bn } from "fuels";

import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Home from "./home";
import Pools from "./pools";
import Config from "./Config";

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/pools/:id" element={<Pools />} />
        <Route path="/config" element={<Config />} />
      </Routes>
    </Router>
  );
}

export default App;
