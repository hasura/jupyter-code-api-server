import React, { useState } from 'react';
import { Transition } from '@headlessui/react';

function Dropdown({ items, onItemClick }) {
  const [isOpen, setIsOpen] = useState(false);
  const [selectedItem, setSelectedItem] = useState(null);

  const toggleDropdown = () => {
    setIsOpen(!isOpen);
  };

  const handleItemClick = (key, value) => {
    setSelectedItem(key);
    onItemClick(value);
    toggleDropdown();
  };

  return (
    <div className="relative inline-block text-left">
      <button
        onClick={toggleDropdown}
        type="button"
        className="bg-white text-black leading-8 font-inter font-semibold text-[14px] rounded-[100px] py-3 px-6 w-72 my-2 focus:outline-none relative border-2 border-black"
        title="Select the .ipynb file to serve the APIs from"
      >
        {selectedItem || 'Select Notebook'}
        <span className={`ml-2 ${isOpen ? 'transform rotate-180' : ''}`}>
          &#9660; {/* ASCII downward arrow */}
        </span>
      </button>
      <Transition
        show={isOpen}
        enter="transition ease-out duration-100 transform"
        enterFrom="opacity-0 scale-95"
        enterTo="opacity-100 scale-100"
        leave="transition ease-in duration-75 transform"
        leaveFrom="opacity-100 scale-100"
        leaveTo="opacity-0 scale-95"
      >
        {(ref) => (
          <div
            ref={ref}
            className="mt-2 w-72 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 focus:outline-none z-50"
          >
            <div className="py-1">
              {Object.keys(items).map((key, index) => (
                <button
                  key={index}
                  onClick={() => handleItemClick(key, items[key])}
                  className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 w-full text-left"
                >
                  {key}
                </button>
              ))}
            </div>
          </div>
        )}
      </Transition>
    </div>
  );
}

export default Dropdown;
