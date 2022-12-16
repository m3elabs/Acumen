import React from 'react';

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