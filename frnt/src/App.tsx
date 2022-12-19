import { useEffect, useState } from "react";
import { TAI64 } from "tai64";
import { Wallet, BN, bn } from "fuels";
import "./App.css";

import { BrowserRouter as Router, Routes, Route}
    from 'react-router-dom';
import Home from './home';
import Pools from './pools';

  
function App() {
return (
    <Router>
   
    <Routes>
      <Route path='/' element={<Home />} />
      <Route path='/pools/:id' element={<Pools />} />
    
    
    </Routes>
    </Router>
);
}

export default App;